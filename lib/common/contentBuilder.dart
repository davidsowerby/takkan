import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_backend/backend/backend.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/script.dart';

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
}
