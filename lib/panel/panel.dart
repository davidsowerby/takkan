import 'package:flutter/material.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_client/backend/backend.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/common/component/heading.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

class Panel extends StatefulWidget {
  final PPanel config;

  Panel({Key key, @required this.config});

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  bool expanded;
  TemporaryDocument temporaryDocument;
  PDataSource dataSourceConfig;
  RootBinding rootBinding;

  @override
  void initState() {
    super.initState();
    expanded = widget.config.heading.openExpanded;
    if (widget.config.dataSourceIsDeclared) {
      temporaryDocument = inject<TemporaryDocument>();
      dataSourceConfig = widget.config.dataSource;
      rootBinding = temporaryDocument.rootBinding;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// If using only static data, we don't care about any data sources
    if (widget.config.isStatic == IsStatic.yes) {
      return _buildContent();
    }

    /// We know this is not static, and if we are not using a data source constructed at this level, then
    /// we create a new DataBinding for this level. Connect its binding and schema to the DataBinding
    /// above this Panel, using this Panel's property.
    if (!widget.config.dataSourceIsDeclared) {
      final DataBinding parentBinding = Provider.of<DataBinding>(context);
      return ChangeNotifierProvider<DataBinding>(
        create: (_) => DataBinding(
          schema: parentBinding.schema.fields[widget.config.property],
          binding: parentBinding.binding.modelBinding(property: widget.config.property),
        ),
        child: _buildContent(),
      );
    }

    /// Now we know we need to construct a data source. [initState] has already created the
    /// TemporaryDocument and RootBinding

    /// Select the configured backend
    final backend = Backend(config: widget.config.backend);
    Widget builder;
    PDocument schema;

    switch (dataSourceConfig.runtimeType) {
      case PDataGet:
        builder = futureBuilder(backend.get(config: dataSourceConfig), temporaryDocument, expanded);
        schema = widget.config.schema.documents[dataSourceConfig.document];
        break;
      case PDataStream:
        builder = streamBuilder(backend, temporaryDocument, expanded);
        break;
      default:
        throw ConfigurationException(
            'Unrecognised data source type:  ${dataSourceConfig.runtimeType}');
    }

    return (widget.config.dataSourceIsDeclared)
        ? ChangeNotifierProvider<DataBinding>(
            create: (_) => DataBinding(binding: rootBinding, schema: schema), child: builder)
        : builder;
  }

  Widget _buildContent() {
    return Heading(
      headingText: widget.config.caption,
      expandedContent: _expandedContent,
      openExpanded: true,
      onAfterSave: [persist],
    );
  }

  Widget futureBuilder(Future<Data> future, TemporaryDocument temporaryDocument, bool expanded) {
    return FutureBuilder<Data>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          temporaryDocument.updateFromSource(source: snapshot.data.data, fireListeners: false);
          return _buildContent();
        } else if (snapshot.hasError) {
          final APIException error = snapshot.error;
          return Text('Error in Future ${error.message}');
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
            return _buildContent();

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

  Widget streamBuilder(Backend backend, TemporaryDocument temporaryDocument, bool expanded) {
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
              return activeBuilder(context, temporaryDocument, snapshot.data, expanded);
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
      BuildContext context, TemporaryDocument temporaryDocument, Data update, bool expanded) {
    temporaryDocument.updateFromSource(source: update.data, fireListeners: false);
    return _buildContent();
  }

  Widget _expandedContent() {
    final editState = Provider.of<EditState>(context, listen: false);
    final content = PanelBuilder().buildContent(context: context, config: widget.config);
    if (editState.readMode) {
      return content;
    } else {
      final formKey = GlobalKey<FormState>();
      addForm(formKey);
      return Form(
          key: formKey,
          child: PanelBuilder().buildContent(context: context, config: widget.config));
    }
  }

  Future<bool> persist(BuildContext context) async {
    flushFormsToModel();
    await _doPersist();
    return true;
  }

  _doPersist() async {
    final Backend backend = Backend(config: widget.config.backend);
    return backend.save(
      data: temporaryDocument,
    );
  }

  final List<GlobalKey<FormState>> formKeys = List();

  /// Called when creating a Form. Sub-Panels may calls this
  /// Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  /// Iterates though form keys registered by [Panels] instances through [addForm], 'saves' the [Form]
  /// that is, transfers data from the [Form] back to the [temporaryDocument] via [Binding]s.
  flushFormsToModel() {
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState.save();
        logType(this.runtimeType).d("Form saved for $key");
      }
    }
    // TODO: purge those with null current state
  }
}
