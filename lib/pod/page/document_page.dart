import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/common/component/edit_save_cancel.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/stream_wrapper.dart';
import 'package:takkan_client/pod/page/document_list_page.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:takkan_client/pod/layout/layout_wrapper.dart';
import 'package:takkan_client/pod/page/standard_page.dart';
import 'package:takkan_client/pod/data_root.dart';
import 'package:takkan_client/pod/document_root.dart';
import 'package:provider/provider.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;
import 'package:takkan_script/script/content.dart';

/// Represents a page displaying a single document.
///
/// This could be used directly, but is generally used only by Takkan to generate
/// pages automatically from [PScript]
///
/// The document is identified by the combination of [dataContext.documentClass]
/// and the selected objectId.
///
/// Although tied to a single document, it may contain panels attached to other documents,
/// so to the end user may appear to contain multiple documents
///
/// To display a list of documents, use [DocumentListPage]
///
/// This is a [StatefulWidget] to support switching between read and edit states, and also
/// to ensure that data is ready before trying to display it.
///
/// [dataContext] encapsulates the link to data in the [DocumentCache].  As a [DocumentRoot]
/// it contains a copy of the original data to enable editing.
///
/// [route] is passed from the [TakkanRouter] during page constructions
///
/// [objectId] is only known on initial construction when this page is from a route based on
/// [DataItemById].  From then on, the objectId may be changed, usually by user action.
///
/// page layout is handled by a nested instance of [LayoutWrapper]
///
/// [pageArguments] are optional and are passed from the [RouteSettings] associated with the route
/// producing this page.  Note that [RouteSettings.arguments] is an Object, but [pageArguments] requires
/// a Map<String,dynamic>
class DocumentPage extends StatefulWidget {
  final PageConfig.Page config;
  final DataContext dataContext;
  final Map<String, dynamic> pageArguments;
  final String? objectId;
  final String route;

  const DocumentPage({
    Key? key,
    required this.config,
    this.objectId,
    required this.dataContext,
    required this.route,
    this.pageArguments = const {},
  }) : super(key: key);

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage> with DocRoot {
  bool needsAuthentication = false;

  DocumentPageState();

  @override
  void initState() {
    super.initState();
    if (widget.objectId != null) {
      _requestDocument(widget.objectId!);
    }
    _checkAuthentication();
    editState = EditState(canEdit: _canEdit());
    editState.registerDocumentRoot(this);
  }

  ModelBinding get modelBinding => cacheEntry.modelBinding;

  DataBinding get dataBinding => DefaultDataBinding(modelBinding);

  @override
  Widget build(BuildContext context) {
    if (needsAuthentication) {
      return Center(child: CircularProgressIndicator());
    }
    if (cacheEntry is NullCacheEntry) {
      return Center(child: CircularProgressIndicator());
    }
    return optionalEditControl(
        widget: Scaffold(
          appBar: AppBar(
            actions: [
              TakkanRefreshButton(),
              EditSaveCancel(),
              IconButton(
                icon: Icon(FontAwesomeIcons.signOutAlt),
                onPressed: () => _doSignOut(context),
              )
            ],
            title: Text(widget.config.title ?? ''),
          ),
          body: Form(
            key: formKey,
            child: StreamWrapper(
              cacheEntry: cacheEntry,
              dataContext: widget.dataContext,
              config: widget.config,
              parentBinding: dataBinding,
              pageArguments: widget.pageArguments,
            ),
          ),
        ),
        config: widget.config);
  }

  /// [formKey] used to identify the Form
  Widget formWhenEditing({
    required Widget content,
  }) {
    if (cacheEntry.isEditable) {
      return Form(key: formKey, child: content);
    }
    return content;
  }

  /// Returns [widget] wrapped in [EditState] if it is not static, and [config.hasEditControl] is true
  /// [EditState.canEdit] is set to reflect whether or not the user has permissions to change the data,
  /// see [_canEdit]
  Widget optionalEditControl(
      {required Widget widget, required Content config}) {
    if (config.isStatic) {
      return widget;
    }

    return (config.hasEditControl)
        ? ChangeNotifierProvider<EditState>.value(
            value: editState, child: widget)
        : widget;
  }

  /// At this stage we only need to check for 'schema.requiresGetAuthentication'
  /// as data is initially in a read state.  Changing the [EditState] to edit,
  /// will check for appropriate write permissions
  ///
  _checkAuthentication() {
    final requiresAuth =
        widget.dataContext.documentSchema.requiresGetAuthentication;
    if (requiresAuth) {
      final userAuthenticated =
          widget.dataContext.dataProvider.authenticator.isAuthenticated;
      needsAuthentication = requiresAuth && !userAuthenticated;
      if (needsAuthentication) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, 'signIn', arguments: {
            'returnRoute': widget.route,
            'signInConfig':
                widget.dataContext.dataProvider.config.signInOptions,
            'dataProvider': widget.dataContext.dataProvider,
          });
        });
      }
      logType(this.runtimeType).d("needs authentication: $needsAuthentication");
    }
  }

  /// Signs out and returns to the root page ('/')
  _doSignOut(BuildContext context) async {
    if (widget.dataContext.dataProvider.authenticator.isAuthenticated) {
      await widget.dataContext.dataProvider.authenticator.signOut();
      Navigator.of(context).pushNamed("/");
    }
  }

  /// Returns false if the document schema is read only.
  ///
  /// If the schema requires user authentication for update, and the user has not
  /// authenticated, returns false.
  ///
  /// True is then returned if the user has any of the roles specified in the schema
  _canEdit() {
    if (widget.dataContext.documentSchema.readOnly) return false;

    if (!widget.dataContext.dataProvider.authenticator.isAuthenticated) {
      if (widget.dataContext.documentSchema.permissions
          .requiresUpdateAuthentication) {
        return false;
      }
    }
    final userRoles = widget.dataContext.dataProvider.userRoles;
    final requiredRoles =
        widget.dataContext.documentSchema.permissions.updateRoles;
    if (requiredRoles.isEmpty) return true;
    final bool userHasPermissions =
        userRoles.any((role) => requiredRoles.contains(role));
    return userHasPermissions;
  }

  /// Requests a document from the cache and sets [cacheEntry] from it.
  /// The [formKey] is removed from the outgoing [cacheEntry], if there is one,
  /// and the new [cacheEntry] has the [formKey] added to it.
  _requestDocument(String objectId) async {
    final doc =
        await widget.dataContext.classCache.requestDocument(objectId: objectId);
    setState(() {
      if (cacheEntry.isEditable) {
        (cacheEntry as EditCacheEntry).removeForm(formKey);
      }
      doc.addForm(formKey);
      cacheEntry = doc;
      currentObjectId = objectId;
    });
  }
}
