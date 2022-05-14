import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/data/cache_entry.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/data/document_cache.dart';
import 'package:precept_client/data/mutable_document.dart';
import 'package:precept_client/library/part_library.dart';
import 'package:precept_client/page/edit_state.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/pod/data_root.dart';
import 'package:precept_client/user/user_state.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:provider/provider.dart';

abstract class PodState<T extends StatefulWidget> extends State<T>
    {
      bool needsAuthentication = false;
  final PPod config;
  final DataContext parentDataContext;
  final Map<String, dynamic> pageArguments;
  bool dataIsReady = false;

  late DocumentClassCache cache;
  late DataContext dataContext;
  late DocumentRoot documentRoot;
  late DataBinding parentBinding;

  /// Only valid when this [PodState] is using a [DataRoot], that is, [config.isDataRoot]
  String _activeId = '';

  PodState({
    required this.config,
    required this.parentDataContext,
    required this.pageArguments,
  }) : super();

  @override
  void initState() {
    super.initState();
    precept.addReadyListener(_onPreceptReady);
    precept.addScriptReloadListener(_onScriptReload);
    _completeContextSetup();
    _checkAuthentication('route');
  }

      // bool get hasModelBinding => !(dataContext.isStatic);

  DataProvider get dataProvider => cache.dataProvider;

  _completeContextSetup() {
    /// This is a completely static page or panel, no dynamic data is used,
    /// so we should disable the ability to select edit
    if (config.isStatic) {
      _disableCanEdit();
      dataContext = StaticDataContext(
        parentDataContext: parentDataContext,
        // config: config,
      );
      return;
    }
    cache = precept.cache.getClassCache(config: config);

    if (config.isDataRoot) {
      _activeId = 'fake-object-id';
      if (_activeId.isNotEmpty) {
        // dataContext = cache.singleRootFor(objectId: _activeId);
      }
    }
  }

  setActiveId(String newId) {
    setState(() {
      _activeId = newId;
      // dataContext = cache.singleRootFor(objectId: _activeId);
    });
  }

  readyStateChange(bool readyState) {
    setState(() {
      dataIsReady = readyState;
    });
  }

  _disableCanEdit() {
    final editState = Provider.of<EditState>(context, listen: false);
    editState.disableCanEdit();
  }

      /// At this stage we only need to check for 'schema.requiresGetAuthentication'
  /// as data is initially in a read state.  Changing the [EditState] to edit,
  /// will check for appropriate permissions
  _checkAuthentication(String route) {
    final requiresAuth = cache.documentSchema.requiresGetAuthentication;
    if (requiresAuth) {
      final userAuthenticated =
          cache.dataProvider.authenticator.isAuthenticated;
      needsAuthentication = requiresAuth && !userAuthenticated;
      if (needsAuthentication) {
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          Navigator.pushNamed(context, 'signIn', arguments: {
            'returnRoute': route,
            'signInConfig': cache.dataProvider.config.signInOptions,
            'dataProvider': cache.dataProvider,
          });
        });
      }
      logType(this.runtimeType).d("needs authentication: $needsAuthentication");
    }
  }

  /// TODO: add to PodListener
  /// Trigger a refresh once Precept fully loaded
  _onPreceptReady() {
    setState(() {});
  }

  /// TODO: add to PodListener
  _onScriptReload() {
    setState(() {});
  }

  /// First checks whether this page requires the user to have permissions, as defined in
  Widget buildContent(ThemeData theme) {
    return assembleContent(theme);
  }

  Widget assembleContent(ThemeData theme);

  /// The result of an attempt to create a document on the server, via a [DataProvider]
  onCreateDocument(CreateResult result) {}

  /// The result of an attempt to update a document on the server, via a [DataProvider]
  onUpdateDocument(UpdateResult result) {}

  doBuild(BuildContext context, ThemeData theme) {
    /// If using only static data, we don't care about any data sources
    if (config.isStatic) {
      return buildContent(theme);
    }

    /// Make sure we don't start before Precept has finished init
    if (precept.isReady) {
      /// The data may not be ready yet
      if (dataIsReady) {
        buildSubContent(
          dataContext: dataContext,
          theme: theme,
          config: this.config,
          pageArguments: pageArguments,
        );
      } else {
        return CircularProgressIndicator();
      }
    } else {
      return CircularProgressIndicator();
    }
  }

  /// Loads data with an expected single result
  // Widget loadData(BuildContext context, ThemeData theme,
  //     Future<ReadResultItem> futureData) {
  //   if (_classCache != null) {
  //     return _loadData(
  //         context, theme, futureData, _classCache!.updateMutableDocument);
  //   }
  //   throw PreceptException('Data cannot be loaded without a DataStore');
  // }

  /// Loads data into [_classCache], using a Future, and returns a Widget produced by [buildContent]
  // Widget _loadData(
  //     BuildContext context,
  //     ThemeData theme,
  //     Future<ReadResultItem> future,
  //     MutableDocument Function(
  //             {required ReadResultItem source,
  //             required DataProvider dataProvider,
  //             required bool fireListeners})
  //         storeData) {
  //   return FutureBuilder<ReadResultItem>(
  //     future: future,
  //     builder: (BuildContext context, AsyncSnapshot<ReadResultItem> snapshot) {
  //       if (snapshot.hasData) {
  //         storeData(
  //             source: snapshot.data!,
  //             dataProvider: dataProvider,
  //             fireListeners: false);
  //         return buildContent(theme);
  //       } else if (snapshot.hasError) {
  //         String msg = 'Error in Future ${snapshot.error.runtimeType}';
  //         logType(this.runtimeType).e(msg);
  //         return Text(msg);
  //       } else {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //     },
  //   );
  // }

  /// retrieves results of a query and stores them in the [_classCache]
  /// Once the connection is made, calls [buildContent]
  // Widget loadList(
  //     ThemeData theme, String queryName, Future<ReadResultList> future) {
  //   return FutureBuilder<ReadResultList>(
  //     future: future,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         _classCache!.storeQueryResults(
  //             queryName: queryName,
  //             queryResults: snapshot.data!.data,
  //             fireListeners: false);
  //         return buildContent(theme);
  //       } else if (snapshot.hasError) {
  //         final error = snapshot.error;
  //         String msg = 'Error in Future ${error.runtimeType}';
  //         logType(this.runtimeType).e(msg);
  //         return Text(msg);
  //       } else {
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.active:
  //           case ConnectionState.done:
  //             return buildContent(theme);
  //           case ConnectionState.none:
  //             String msg = 'Error in Future, it may have returned null';
  //             logType(this.runtimeType).e(msg);
  //             return Text(msg);
  //           case ConnectionState.waiting:
  //             return Center(child: CircularProgressIndicator());
  //         }
  //       }
  //     },
  //   );
  // }

  Widget streamBuilder(
      DataProvider backend, MutableDocument temporaryDocument) {
    // return StreamBuilder<Data>(
    //     stream: backend.getStream(documentId: null),
    //     initialData: Data(data: {}),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.none:
    //           return Center(
    //             child: Text('No connection'),
    //           );
    //         case ConnectionState.waiting:
    //           return Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         case ConnectionState.active:
    //           return activeBuilder(
    //             temporaryDocument,
    //             snapshot.data,
    //           );
    //         case ConnectionState.done:
    //           return Center(
    //             child: Text("Connection closed"),
    //           );
    //         default:
    //           return null; // unreachable
    //       }
    //     });
    throw UnimplementedError();
  }

  /// Updates data and rebuilds using [buildContent]
  Widget activeBuilder(
      ThemeData theme, MutableDocument temporaryDocument, Data update) {
    temporaryDocument.updateFromSource(
        source: update.data,
        documentId: update.documentId,
        fireListeners: false);
    return buildContent(theme);
  }

  /// Build any nested Panel or Part widgets. Not used by Part
  Widget buildSubContent({
    required ThemeData theme,
    required DataContext dataContext,
    required PPod config,
    required Map<String, dynamic> pageArguments,
  }) {
    final List<Widget> children = List.empty(growable: true);
    for (var element in config.children) {
      late Widget child;
      if (element is PPanel) {
        child = Panel(
          config: element,
          pageArguments: pageArguments,
          dataContext: dataContext,
        );
      }
      if (element is PPart) {
        child = partLibrary.partBuilder(
            partConfig: element,
            theme: theme,
            dataContext: dataContext,
            parentBinding: parentBinding,
            pageArguments: pageArguments);
      }
      child = addUserState(widget: child, config: config);
      child = addEditControl(widget: child, config: element);
      children.add(child);
    }
    final screenSize = MediaQuery.of(context).size;
    return layout(children: children, screenSize: screenSize, config: config);
  }

  Widget layout(
      {required List<Widget> children,
      required Size screenSize,
      required PPod config});

  addUserState({required Widget widget, required PPod config}) {
    if (config.dataProviderIsDeclared) {
      return ChangeNotifierProvider<UserState>(
          create: (_) => UserState(cache.dataProvider.authenticator),
          child: widget);
    } else {
      return widget;
    }
  }

  /// Returns [widget] wrapped in [EditState] if it is not static, and [config.hasEditControl] is true
  /// [EditState.canEdit] is set to reflect whether or not the user has permissions to change the data,
  /// see [_canEdit]
  Widget addEditControl({required Widget widget, required PContent config}) {
    if (config.isStatic) {
      return widget;
    }

    return (config.hasEditControl)
        ? ChangeNotifierProvider<EditState>(
            create: (_) => EditState(canEdit: _canEdit()), child: widget)
        : widget;
  }

      /// Returns false if the [dataContext.documentSchema] is read only.
  ///
  /// If the schema requires user authentication for update,and the user has not authenticated
  /// returns false.
  ///
  /// True is then returned if the user has any of the roles specified in the schema
  _canEdit() {
    if (cache.documentSchema.readOnly) return false;

    if (!cache.dataProvider.authenticator.isAuthenticated) {
      if (cache.documentSchema.permissions.requiresUpdateAuthentication) {
        return false;
      }
    }
    final userRoles = cache.dataProvider.userRoles;
    final requiredRoles = cache.documentSchema.permissions.updateRoles;
    if (requiredRoles.isEmpty) return true;
    final bool userHasPermissions =
        userRoles.any((role) => requiredRoles.contains(role));
    return userHasPermissions;
  }

  /// [formKey] must be provided from outside the [build] method
  Widget wrapInForm(
    BuildContext context,
    Widget content,
    GlobalKey<FormState> formKey,
  ) {
    documentRoot.addForm(formKey);
    return Form(key: formKey, child: content);
  }
}

/// Brings together several callbacks for a [PodState] instance, which collectively
/// keep the [PodState] up to date with the status of its data.
///
/// Did consider using a GlobalKey<Form>, but there is a possibility
/// that something else may want notifications via these callbacks.
// abstract class DataListener {
//   /// The result of an attempt to create a document on the server, via a [DataProvider]
//   onCreateDocument(CreateResult result);
//
//   /// The result of an attempt to update a document on the server, via a [DataProvider]
//   onUpdateDocument(UpdateResult result);
//
//   void readyStateChange(bool isReady) {}
// }
//
// abstract class DataNotifier {
//   List<DataListener> get listeners;
//
//   addListener(DataListener listener);
//
//   removeListener(DataListener listener);
// }

/// From DataRoot - use for PodState??

// /// Returns true if a [PSingle] has a fixed or selected objectId, enabling it
// /// to query for data.  Put simply it knows which data it should be looking for.
// ///
// /// False is returned when a a selected id is expected, but nbo selection has
// /// yet been made.
// bool get isActive {
//   final pData = config.data;
//   if (pData is PSingle) {
//     return (pData.objectId != null) || (_currentSelectionId != null);
//   }
//   return false;
// }
//
// String get activeId {
//   if (isActive) {
//     final PSingle single = config.data as PSingle;
//     return single.objectId ?? _currentSelectionId!;
//   }
//   throw PreceptException(
//       'Must be active to have an activeId.  Check isActive first');
// }
/// [dataProvider] is used primarily to give access to the [PreceptUser] object
/// it contains
///
/// [documentSchema] provides the structure, permissions and validation for the document.
