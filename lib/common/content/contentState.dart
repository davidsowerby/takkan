import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_client/app/precept.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataProviderState.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/library/particleLibrary.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

abstract class ContentState<T extends StatefulWidget, CONFIG extends PContent> extends State<T> {
  static const String preloadDataKey = 'preload-data';
  DataSource dataSource;
  DataBinding dataBinding;
  DataProvider dataProvider;

  final PContent config;
  final DataBinding parentBinding;
  final Map<String, dynamic> pageArguments;

  ContentState(this.config, this.parentBinding, this.pageArguments) : super();

  @override
  void initState() {
    super.initState();
    if (config.dataProvider != null) {
      /// Call is not actioned if Precept already in ready state
      precept.addReadyListener(_onPreceptReady);
      dataProvider = dataProviderLibrary.find(config: config.dataProvider);
    }
    final String dataTable = (config.queryIsDeclared)
        ? config.query.table
        : (preloaded)
            ? pageArguments[preloadDataKey]['__typename'] // TODO: back4app specific
            : null;
    dataSource = DataSource(config, dataProvider, preloaded, dataTable);
    if (config is PPart) {
      dataBinding = NoDataBinding();
    } else {
      dataBinding = (preloaded)
          ? parentBinding.rootFromPreloadedData(dataSource)
          : parentBinding.child(config, parentBinding, dataSource);
    }
  }

  bool get preloaded => ((pageArguments != null) && pageArguments[preloadDataKey] != null);

  /// Trigger a refresh once Precept fully loaded
  _onPreceptReady() {
    setState(() {});
  }

  Widget buildContent(ThemeData theme) {
    return ChangeNotifierProvider<DataProviderState>(
        create: (_) => DataProviderState(dataProvider), child: assembleContent(theme));
  }

  Widget assembleContent(ThemeData theme);

  doBuild(BuildContext context, ThemeData theme, DataSource dataSource, PContent config,
      Map<String, dynamic> pageArguments) {
    assert(pageArguments != null);

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

      switch (config.query.returnType) {
        case QueryReturnType.futureSingle:
          return loadData(
              context,
              theme,
              dataProvider.query(
                query: query,
                pageArguments: pageArguments,
              ));
        case QueryReturnType.futureList:
          return loadList(
              theme,
              query.name,
              dataProvider.queryList(
                query: query,
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
  Widget _loadData<T>(
      BuildContext context,
      ThemeData theme,
      Future<T> future,
      TemporaryDocument Function({T source, DataProvider dataProvider, bool fireListeners})
          storeData) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          storeData(source: snapshot.data, dataProvider: dataProvider, fireListeners: false);
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
              queryName: queryName, queryResults: snapshot.data, fireListeners: false);
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
          return null; // unreachable
        }
      },
    );
  }

  Widget streamBuilder(DataProvider backend, TemporaryDocument temporaryDocument) {
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
  Widget activeBuilder(ThemeData theme, TemporaryDocument temporaryDocument, Data update) {
    temporaryDocument.updateFromSource(
        source: update.data, documentId: update.documentId, fireListeners: false);
    return buildContent(theme);
  }

  /// Build any nested Panel or Part widgets. Not used by Part
  Widget buildSubContent({
    ThemeData theme,
    DataBinding parentBinding,
    CONFIG config,
    Map<String, dynamic> pageArguments,
  }) {
    assert(parentBinding != null);

    /// There is no common interface for the 'content' property of PPage and PPanel.
    /// Perhaps there should be

    final List<PSubContent> content =
        (config is PPanel) ? config.content : (config as PPage).content;
    final List<Widget> children = List.empty(growable: true);
    for (var element in content) {
      Widget child;
      if (element is PPanel) {
        child = Panel(
          parentBinding: parentBinding,
          config: element,
          pageArguments: pageArguments,
        );
      }
      if (element is PPart) {
        child = particleLibrary.partBuilder(
            partConfig: element,
            theme: theme,
            dataBinding: dataBinding,
            pageArguments: pageArguments);
      }
      child = addEditControl(widget: child, config: element);
      children.add(child);
    }
    final screenSize = MediaQuery.of(context).size;
    return layout(children: children, screenSize: screenSize, config: config);
  }

  Widget layout({List<Widget> children, Size screenSize, CONFIG config});

  /// Returns [widget] wrapped in [EditState] if it is not static, and [config.hasEditControl] is true
  Widget addEditControl({@required Widget widget, @required PCommon config}) {
    if (config.isStatic == IsStatic.yes) {
      return widget;
    }
    return (config.hasEditControl)
        ? ChangeNotifierProvider<EditState>(create: (_) => EditState(), child: widget)
        : widget;
  }

  /// [formKey] must be provided from outside the [build] method
  Widget wrapInForm(
      BuildContext context, Widget content, DataBinding dataBinding, GlobalKey<FormState> formKey) {
    dataBinding.addForm(formKey);
    return Form(key: formKey, child: content);
  }
}

class SnapshotBuilder {
  final List<Data> snapshot;
  final PContent config;

  const SnapshotBuilder(this.snapshot, this.config);

  buildItem(BuildContext context, int index, PContent config) {}
}
