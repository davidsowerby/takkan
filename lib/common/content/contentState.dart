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
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/script/element.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

abstract class ContentState<T extends StatefulWidget, CONFIG extends PContent> extends State<T> {
  DataSource dataSource;
  DataBinding dataBinding;
  DataProvider dataProvider;

  final PContent config;
  final DataBinding parentBinding;

  ContentState(this.config, this.parentBinding) : super();

  @override
  void initState() {
    super.initState();
    if (config.dataProvider != null) {
      /// Call is not actioned if Precept already in ready state
      precept.addReadyListener(_onPreceptReady);
      dataProvider = dataProviderLibrary.find(config: config.dataProvider);
    }
    dataSource = DataSource(config);
    if (config is PPart) {
      dataBinding = NoDataBinding();
    } else {
      dataBinding = parentBinding.child(config, parentBinding, dataSource);
    }
  }

  _onPreceptReady() {
    setState(() {});
  }

  Widget buildContent() {
    return ChangeNotifierProvider<DataProviderState>(
        create: (_) => DataProviderState(dataProvider), child: assembleContent());
  }

  Widget assembleContent();

  doBuild(BuildContext context, DataSource dataSource, PContent config,
      Map<String, dynamic> pageArguments) {
    assert(pageArguments != null);

    /// If using only static data, we don't care about any data sources
    if (config.isStatic == IsStatic.yes) {
      return buildContent();
    }

    if (!config.queryIsDeclared) {
      return buildContent();
    }

    /// Now we know we need to construct a data source. [initState] has already created the
    /// TemporaryDocument and RootBinding

    final query = config.query;

    /// Make sure we don't start before Precept has finished init
    if (precept.isReady) {
      return futureBuilder(dataProvider.query(query: query, pageArguments: pageArguments),
          dataSource.temporaryDocument);
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget futureBuilder(Future<Data> future, TemporaryDocument temporaryDocument) {
    return FutureBuilder<Data>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          temporaryDocument.updateFromSource(
              source: snapshot.data.data,
              documentId: snapshot.data.documentId,
              fireListeners: false);
          return buildContent();
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          return Text('Error in Future ${error.runtimeType}');
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              return buildContent();

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
  Widget activeBuilder(TemporaryDocument temporaryDocument, Data update) {
    temporaryDocument.updateFromSource(
        source: update.data, documentId: update.documentId, fireListeners: false);
    return buildContent();
  }

  /// Build any nested Panel or Part widgets. Not used by Part
  Widget buildSubContent(
      {DataBinding parentBinding, CONFIG config, Map<String, dynamic> pageArguments}) {
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
        child = Part(
          parentBinding: parentBinding,
          config: element,
          pageArguments: pageArguments,
        );
      }
      child = addEditControl(widget: child, config: element);
      children.add(child);
    }
    final screenSize = MediaQuery.of(context).size;
    return layout(children: children, screenSize: screenSize, config:config);
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
  Widget wrapInForm(BuildContext context, Widget content, DataBinding dataBinding, GlobalKey<FormState> formKey) {
    dataBinding.addForm(formKey);
    return Form(key: formKey, child: content);
  }
}
