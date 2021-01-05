import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/backend.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataSource.dart';
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

  Future<bool> persist(PCommon config, TemporaryDocument temporaryDocument,
      List<GlobalKey<FormState>> formKeys) async {
    flushFormsToModel(temporaryDocument, formKeys);
    await _doPersist(config, temporaryDocument);
    return true;
  }

  _doPersist(PCommon config, TemporaryDocument temporaryDocument) async {
    final Backend backend = Backend(config: config.backend);
    return backend.save(
      changedData: temporaryDocument.changes,
      fullData: temporaryDocument.output,
      onSuccess: temporaryDocument.saved,
    );
  }

  /// Iterates though form keys registered by Pages, Panels or Parts using the same [temporaryDocument] instances through [addForm], 'saves' the [Form]
  /// that is, transfers data from the [Form] back to the [temporaryDocument] via [Binding]s.
  flushFormsToModel(TemporaryDocument temporaryDocument, List<GlobalKey<FormState>> formKeys) {
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState.save();
        logType(this.runtimeType).d("Form saved for $key");
      }
    }
    // TODO: purge those with null current state
  }

  doBuild(BuildContext context, TemporaryDocument temporaryDocument, PContent config,
      Widget Function() buildContent) {
    /// If using only static data, we don't care about any data sources
    if (config.isStatic == IsStatic.yes) {
      return buildContent();
    }

    /// We know this is not static, and if we are not using a data source constructed at this level, then
    /// we create a new DataBinding for this level. Connect its binding and schema to the DataBinding
    /// above this Panel, using this Panel's property.
    if (!config.dataSourceIsDeclared) {
      final DataBinding parentBinding = Provider.of<DataBinding>(context);
      return ChangeNotifierProvider<DataBinding>(
        create: (_) => DataBinding(
          schema: parentBinding.schema.fields[config.property],
          binding: parentBinding.binding.modelBinding(property: config.property),
        ),
        child: buildContent(),
      );
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
        builder =
            futureBuilder(backend.get(config: dataSourceConfig), temporaryDocument, buildContent);
        schema = config.schema.documents[dataSourceConfig.document];
        break;
      case PDataStream:
        builder = streamBuilder(backend, temporaryDocument, buildContent);
        break;
      default:
        throw ConfigurationException(
            'Unrecognised data source type:  ${dataSourceConfig.runtimeType}');
    }

    return (config.dataSourceIsDeclared)
        ? ChangeNotifierProvider<DataBinding>(
            create: (_) => DataBinding(binding: temporaryDocument.rootBinding, schema: schema),
            child: builder)
        : builder;
  }

  Widget formWrapped(BuildContext context, Widget content, List<GlobalKey<FormState>> formKeys) {
    final editState = Provider.of<EditState>(context, listen: false);
    if (editState.readMode) {
      return content;
    } else {
      final formKey = GlobalKey<FormState>();
      addForm(formKeys, formKey);
      return Form(key: formKey, child: content);
    }
  }

  /// Stores a key for a Form.
  /// Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(List<GlobalKey<FormState>> formKeys, GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }
}
