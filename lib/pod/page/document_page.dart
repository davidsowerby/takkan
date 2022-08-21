import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/common/component/edit_save_cancel.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/stream_wrapper.dart';
import 'package:takkan_client/pod/page/document_list_page.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:takkan_client/pod/layout/layout_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/select/data_selector.dart';
import 'package:takkan_script/page/page.dart' as PageConfig;
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/script/content.dart';

import '../../common/component/takkan_refresh_button.dart';
import '../../data/cache_consumer.dart';

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
  final TakkanRoute route;

  const DocumentPage({
    Key? key,
    required this.config,
    required this.dataContext,
    required this.route,
    this.pageArguments = const {},
  }) : super(key: key);

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage> with CacheConsumer {
  bool needsAuthentication = false;
  CacheEntry? _cacheEntry;

  final _formKey = GlobalKey<FormState>();
  String? currentObjectId;
  late EditState editState;
  bool hasData = false;
  late DocumentSelector dataSelector;

  DocumentPageState();

  @override
  void initState() {
    super.initState();
    dataSelector = widget.config
        .dataSelectorByName(widget.route.dataSelectorName) as DocumentSelector;

    /// Issue request for document, cache will notify us when it arrives
    _requestData(dataSelector: dataSelector);
    _checkAuthentication();
    editState = EditState(canEdit: _canEdit());
    editState.addDocumentRoot(this);
  }

  ModelBinding get modelBinding => cacheEntry.modelBinding;

  /// The [_cacheEntry] is either being changed (a different document has been
  /// selected), or its data is being updated
  ///
  /// if this is a new[_cacheEntry]:
  ///
  /// - The [_formKey] is removed from the outgoing [cacheEntry], if there is one
  /// - the new [_cacheEntry] has the [_formKey] added to it.
  void _updateCacheEntry(CacheEntry newEntry) {
    setState(() {
      final ce = _cacheEntry;

      if (ce != null) {
        ce.removeConsumer(this);
        ce.removeForm(_formKey);
      }
      newEntry.addConsumer(this);
      newEntry.addForm(_formKey);
      _cacheEntry = newEntry;
    });
  }

  CacheEntry get cacheEntry {
    final ce = _cacheEntry;
    if (ce != null) return ce;
    final String msg = '_cacheEntry is null';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  DataBinding get dataBinding => DefaultDataBinding(modelBinding);

  @override
  Widget build(BuildContext context) {
    if (needsAuthentication) {
      return Center(child: CircularProgressIndicator());
    }
    final ce = _cacheEntry;
    if (ce == null) {
      return Center(child: Text('No data selected'));
    }
    if (ce.dataIsNotLoaded) {
      return Center(child: Text('No data available'));
    }

    return optionalEditState(
        widget: Scaffold(
          appBar: AppBar(
            actions: [
              TakkanRefreshButton(),
              if (widget.config.hasEditControl)
                EditSaveCancel(
                  cacheEntry: cacheEntry,
                ),
              IconButton(
                icon: Icon(FontAwesomeIcons.signOutAlt),
                onPressed: () => _doSignOut(context),
              )
            ],
            title: Text(widget.config.title ?? ''),
          ),
          body: Form(
            key: _formKey,
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


  /// Returns [widget] wrapped in [EditState] if [config.hasEditControl] is true
  /// [EditState.canEdit] is set to reflect whether or not the user has permissions to change the data,
  /// see [_canEdit]
  Widget optionalEditState({required Widget widget, required Content config}) {
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

  /// Requests a document or list of documents from the cache and sets
  /// [cacheEntry] from it.
  ///
  /// [_updateCacheEntry] is a callback invoked once an existing CacheEntry has been
  /// located in the cache, or a new one created after retrieving data from the
  /// server.
  void _requestData({
    required DocumentSelector dataSelector,
  }) {
    widget.dataContext.classCache.requestDocument(
        dataSelector: dataSelector, callback: _updateCacheEntry);
  }

  @protected
  @mustCallSuper
  @override
  void dispose() {
    cacheEntry.removeForm(_formKey);
    cacheEntry.removeConsumer(this);
    super.dispose();
  }
}
