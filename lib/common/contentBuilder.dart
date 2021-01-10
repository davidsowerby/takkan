import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/backend.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/element.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

mixin ContentBuilder {
  Widget futureBuilder(
      Future<Data> future, TemporaryDocument temporaryDocument, Widget Function() buildContent) {
    return FutureBuilder<Data>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          temporaryDocument.updateFromSource(source: snapshot.data.data, fireListeners: false);
          return buildContent();
        } else if (snapshot.hasError) {
          final APIException error = snapshot.error;
          return Text('Error in Future ${error.message}');
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

  Widget streamBuilder(
      Backend backend, TemporaryDocument temporaryDocument, Widget Function() buildContent) {
    return StreamBuilder<Data>(
        stream: backend.getStream(documentId: null),
        initialData: Data(data: {}),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('No connection'),
              );
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return activeBuilder(temporaryDocument, snapshot.data, buildContent);
            case ConnectionState.done:
              return Center(
                child: Text("Connection closed"),
              );
            default:
              return null; // unreachable
          }
        });
  }

  /// Updates data and rebuilds using [PanelBuilder]
  Widget activeBuilder(
      TemporaryDocument temporaryDocument, Data update, Widget Function() buildContent) {
    temporaryDocument.updateFromSource(source: update.data, fireListeners: false);
    return buildContent();
  }

  doBuild(BuildContext context, LocalContentState contentState, PContent config,
      Widget Function() buildContent) {
    /// If using only static data, we don't care about any data sources
    if (config.isStatic == IsStatic.yes) {
      return buildContent();
    }

    /// We know this is not static, and if we are not using a data source constructed at this level, then
    /// we create a new DataBinding for this level, but only for Part or Panel.

    if (!config.dataSourceIsDeclared) {
      /// A Page cannot have a DataBinding above it, except when created as part of a [DataSource],
      /// and we wouldn't be here then
      if (config is PPage) {
        return buildContent();
      }

      ///  Connect its binding and schema to the DataBinding above this content, using this content's property.
      return buildContent();
    }

    /// Now we know we need to construct a data source. [initState] has already created the
    /// TemporaryDocument and RootBinding

    /// Select the configured backend
    final backend = Backend(config: config.backend);
    final dataSourceConfig = config.dataSource;
    Widget builder;
    PDocument schema;

    switch (dataSourceConfig.runtimeType) {
      case PDataGet:
        builder = futureBuilder(
            backend.get(config: dataSourceConfig), contentState.temporaryDocument, buildContent);
        schema = config.schema.documents[dataSourceConfig.document];
        break;
      case PDataStream:
        builder = streamBuilder(backend, contentState.temporaryDocument, buildContent);
        break;
      default:
        final msg = 'Unrecognised data source type:  ${dataSourceConfig.runtimeType}';
        logType(this.runtimeType).e(msg);
        throw ConfigurationException(msg);
    }

    return builder;
  }

  Widget formWrapped(BuildContext context, Widget content, DataBinding dataBinding) {
    final editState = Provider.of<EditState>(context, listen: false);
    if (editState.readMode) {
      return content;
    } else {
      final formKey = GlobalKey<FormState>();
      dataBinding.addForm(formKey);
      return Form(key: formKey, child: content);
    }
  }

  Widget assembleContent({DataBinding parentBinding, List<PSubContent> content, bool scrollable}) {
    assert(parentBinding != null);
    final List<Widget> children = List();
    for (var element in content) {
      Widget child;
      if (element is PPanel) {
        child = Panel(
          parentBinding: parentBinding,
          config: element,
        );
      }
      if (element is PPart) {
        child = Part(
          parentBinding: parentBinding,
          config: element,
        );
      }
      child = addEditControl(widget: child, config: element);
      children.add(child);
    }
    return (scrollable)
        ? ListView(children: children)
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  /// Returns [widget] wrapped in [EditState] if it is not static, and [config.hasEditControl] is true
  Widget addEditControl({@required Widget widget, @required PCommon config}) {
    if (config.isStatic == IsStatic.yes) {
      return widget;
    }
    return (config.hasEditControl)
        ? ChangeNotifierProvider<EditState>(create: (_) => EditState(), child: widget)
        : widget;
  }
}

abstract class ContentState {
  Widget buildContent();
}
