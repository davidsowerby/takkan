import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataProviderState.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/library/partLibrary.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/user/userState.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/constants.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/schema/field/queryResult.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

abstract class ContentState<T extends StatefulWidget, CONFIG extends PContent> extends State<T> {
  static const String preloadDataKey = 'preload-data';
  bool needsAuthentication = false;
  final ContentBindings contentBindings;

  ContentState(PContent config,
      DataBinding parentBinding,
      Map<String, dynamic> pageArguments,)
      : contentBindings = ContentBindings(config, parentBinding, pageArguments),
        super();

  @override
  void initState() {
    super.initState();
    contentBindings.init(_onPreceptReady);
    if (!(contentBindings.dataBinding is NoDataBinding)) {
      if (contentBindings.dataBinding.schema.readOnly) {
        final editState = Provider.of<EditState>(context, listen: false);
        editState.disableCanEdit();
      }
    }
    precept.addScriptReloadListener(_onScriptReload);
    final requiresAuth =
    (dataBinding is NoDataBinding) ? false : dataBinding.schema.requiresReadAuthentication;
    if (requiresAuth) {
      dataProvider.createAuthenticator();
      final userAuthenticated = dataProvider.authenticator.isAuthenticated;
      needsAuthentication = requiresAuth && !userAuthenticated;
      if (needsAuthentication) {
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          Navigator.pushNamed(context, 'signIn', arguments: {
            'returnRoute': (config as PPage).route,
            'signInConfig': dataProvider.config.signInOptions,
            'dataProvider': dataProvider,
          });
        });
      }
      logType(this.runtimeType).d("needs authentication: $needsAuthentication");
    }
  }

  /// Trigger a refresh once Precept fully loaded
  _onPreceptReady() {
    setState(() {});
  }

  _onScriptReload() {
    setState(() {});
  }

  /// First checks whether this page requires the user to have permissions, as defined in
  Widget buildContent(ThemeData theme) {
    return ChangeNotifierProvider<DataProviderState>(
        create: (_) => DataProviderState(dataProvider), child: assembleContent(theme));
  }

  Widget assembleContent(ThemeData theme);

  doBuild(BuildContext context, ThemeData theme, DataSource dataSource, PContent config,
      Map<String, dynamic> pageArguments) {

    /// If using only static data, we don't care about any data sources
    if (config.isStatic == IsStatic.yes) {
      return buildContent(theme);
    }

    if (!config.queryIsDeclared && !preloaded) {
      return buildContent(theme);
    }

    /// Now we know we need to construct a data source. [initState] has already created the
    /// TemporaryDocument and RootBinding

    final query = config.query;

    /// Make sure we don't start before Precept has finished init
    if (precept.isReady) {
      /// if data has been passed to the page during construction (usually as a result of navigating
      /// from a query result list), we don't need to invoke a query, but we want to use the same
      /// mechanism

      if (preloaded) {
        return loadData(
          context,
          theme,
          _preloadData(),
        );
      }

      if (query == null) {
        throw PreceptException('It should not be possible to get here without a defined query');
      }

      switch (query.returnType) {
        case QueryReturnType.futureSingle:
          return loadData(
              context,
              theme,
              dataProvider.query(
                queryConfig: query,
                pageArguments: pageArguments,
              ));
        case QueryReturnType.futureList:
          return loadList(
              theme,
              query.querySchema,
              dataProvider.queryList(
                queryConfig: query,
                pageArguments: pageArguments,
              ));
        case QueryReturnType.streamSingle:
        // TODO: Handle this case.
          break;
        case QueryReturnType.streamList:
        // TODO: Handle this case.
          break;
      }
    } else {
      return CircularProgressIndicator();
    }
  }

  Future<Map<String, dynamic>> _preloadData() async {
    return pageArguments[ContentState.preloadDataKey];
  }

  /// Loads data with an expected single result
  Widget loadData(BuildContext context, ThemeData theme, Future<Map<String, dynamic>> future) {
    return _loadData<Map<String, dynamic>>(context, theme, future, dataSource.updateDocument);
  }

  /// Loads data into [dataSource], using a Future, and returns a Widget produced by [buildContent]
  Widget _loadData<T>(BuildContext context,
      ThemeData theme,
      Future<T> future,
      MutableDocument Function(
          {required T source, required DataProvider dataProvider, required bool fireListeners})
      storeData) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          storeData(source: snapshot.data!, dataProvider: dataProvider, fireListeners: false);
          return buildContent(theme);
        } else if (snapshot.hasError) {
          return Text('Error in Future ${snapshot.error.runtimeType}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /// retrieves results of a query and stores them in the [dataSource]
  /// Once the connection is made, calls [buildContent]
  Widget loadList(ThemeData theme, String queryName, Future<List<Map<String, dynamic>>> future) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dataSource.storeQueryResults(
              queryName: queryName, queryResults: snapshot.data!, fireListeners: false);
          return buildContent(theme);
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          return Text('Error in Future ${error.runtimeType}');
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              return buildContent(theme);
            case ConnectionState.none:
              return Text('Error in Future, it may have returned null');
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }

  Widget streamBuilder(DataProvider backend, MutableDocument temporaryDocument) {
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
  Widget activeBuilder(ThemeData theme, MutableDocument temporaryDocument, Data update) {
    temporaryDocument.updateFromSource(
        source: update.data, documentId: update.documentId, fireListeners: false);
    return buildContent(theme);
  }

  /// Build any nested Panel or Part widgets. Not used by Part
  Widget buildSubContent({
    required ThemeData theme,
    required DataBinding parentBinding,
    required CONFIG config,
    required Map<String, dynamic> pageArguments,
  }) {
    /// There is no common interface for the 'content' property of PPage and PPanel.
    /// Perhaps there should be

    final List<PSubContent> content =
    (config is PPanel) ? config.content : (config as PPage).content;
    final List<Widget> children = List.empty(growable: true);
    for (var element in content) {
      late Widget child;
      if (element is PPanel) {
        child = Panel(
          parentBinding: parentBinding,
          config: element,
          pageArguments: pageArguments,
        );
      }
      if (element is PPart) {
        child = partLibrary.partBuilder(
            partConfig: element,
            theme: theme,
            contentBindings: contentBindings,
            pageArguments: pageArguments);
      }
      child = addUserState(widget: child, config: config);
      child = addEditControl(widget: child, config: element);
      children.add(child);
    }
    final screenSize = MediaQuery
        .of(context)
        .size;
    return layout(children: children, screenSize: screenSize, config: config);
  }

  Widget layout({required List<Widget> children, required Size screenSize, required CONFIG config});

  addUserState({required Widget widget, required PCommon config}) {
    if (config.dataProviderIsDeclared) {
      return ChangeNotifierProvider<UserState>(
          create: (_) => UserState(dataProvider.authenticator), child: widget);
    } else {
      return widget;
    }
  }

  /// Returns [widget] wrapped in [EditState] if it is not static, and [config.hasEditControl] is true
  /// [EditState.canEdit] is set to reflect whether or not the user has permissions to change the data,
  /// see [_canEdit]
  Widget addEditControl({required Widget widget, required PCommon config}) {
    if (config.isStatic == IsStatic.yes) {
      return widget;
    }

    return (config.hasEditControl)
        ? ChangeNotifierProvider<EditState>(
        create: (_) => EditState(canEdit: _canEdit()), child: widget)
        : widget;
  }

  /// Returns false if there is no [dataProvider], or the [dataProvider.schema] is read only,
  /// as it does not make sense to edit something that cannot be saved.
  /// If the user has not authenticated, and the schema requires authentication for update,
  /// false is returned
  /// True is then returned if the user has any of the roles specified in the schema
  _canEdit() {
    if (dataBinding is NoDataBinding) return false;
    if (dataBinding.schema.readOnly) return false;

    if (!dataProvider.authenticator.isAuthenticated) {
      if (dataBinding.schema.permissions.requiresUpdateAuthentication) {
        return false;
      }
    }
    final userRoles = dataProvider.userRoles;
    final requiredRoles = dataBinding.schema.permissions.updateRoles;
    if (requiredRoles.isEmpty) return true;
    final bool userHasPermissions = userRoles.any((role) => requiredRoles.contains(role));
    return userHasPermissions;
  }

  /// [formKey] must be provided from outside the [build] method
  Widget wrapInForm(BuildContext context, Widget content, DataBinding dataBinding,
      GlobalKey<FormState> formKey) {
    dataBinding.addForm(formKey);
    return Form(key: formKey, child: content);
  }

  DataBinding get dataBinding => contentBindings.dataBinding;

  DataProvider get dataProvider => contentBindings.dataProvider;

  bool get preloaded => contentBindings.preloaded;

  Map<String, dynamic> get pageArguments => contentBindings.pageArguments;

  DataSource get dataSource => contentBindings.dataSource;

  PContent get config => contentBindings.config;
}

/// A wrapper to hold all the data related bindings and configuration associated with [ContentState].
///  This is passed to the [PartLibrary] so that widgets provided through the library can access
///  these bindings.
class ContentBindings {
  late DataSource dataSource;
  late DataBinding dataBinding;
  late DataProvider dataProvider;

  final PContent config;
  final DataBinding parentBinding;
  final Map<String, dynamic> pageArguments;
  final DateTime timestamp = DateTime.now();

  ContentBindings(this.config, this.parentBinding, this.pageArguments);

  init(Function() _onPreceptReady) async {
    if (config.dataProvider != null && !(config.dataProvider is PNoDataProvider)) {
      /// Call is not actioned if Precept already in ready state
      precept.addReadyListener(_onPreceptReady);
      dataProvider = dataProviderLibrary.find(config: config.dataProvider!);
    }
    final String documentSchemaName = (config.queryIsDeclared)
        ? lookupDocumentSchemaName()
        : (preloaded)
        ? pageArguments[ContentState.preloadDataKey]['__typename'] // TODO: back4app specific
        : notSet;

    dataSource = DataSource(
        config: config,
        dataProvider: dataProvider,
        preloadedData: preloaded,
        documentSchema: lookupDocumentSchema(documentSchemaName));
    if (config is PPart) {
      dataBinding = NoDataBinding();
    } else {
      dataBinding = (preloaded)
          ? parentBinding.rootFromPreloadedData(dataSource)
          : parentBinding.child(config, parentBinding, dataSource);
    }
  }

  PDocument? lookupDocumentSchema(String documentSchemaName) {
    if (documentSchemaName == notSet) {
      return null;
    }
    final PSchema schema = dataProvider.config.schema;
    return schema.document(documentSchemaName);
  }

  String lookupDocumentSchemaName() {
    final PSchema? schema = dataProvider.config.schema;
    if (schema == null) {
      throw PreceptException('Schema cannot be null when looking up document schema');
    }
    final PQuerySchema? querySchema = schema.queries[config.query?.querySchema];
    if (querySchema == null) {
      throw PreceptException(
          "querySchema for '${config.query?.querySchema}' must be defined for PSchema ${schema
              .name}");
    }
    return querySchema.documentSchema;
  }

  /// Preloaded data is held at page level
  bool get preloaded =>
      ((config is PPage) &&
          pageArguments[ContentState.preloadDataKey] != null);
}
