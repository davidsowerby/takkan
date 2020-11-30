import 'package:flutter/material.dart';
import 'package:precept_client/assembler/pageAssembler.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/document/documentController.dart';
import 'package:precept_client/precept/document/documentState.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:provider/provider.dart';

class Document extends StatelessWidget {
  final Stream<Map<String, dynamic>> documentDataStream;
  final PPage config;
  final RootBinding rootBinding;

  Document({Key key, @required this.config, @required this.rootBinding})
      : documentDataStream =
            inject<DocumentController>().getDocument(config.document.documentSelector),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final DocumentState documentState = Provider.of<DocumentState>(context);
    return StreamBuilder<Map<String, dynamic>>(
        stream: documentDataStream,
        initialData: {},
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
              return activeBuilder(context, documentState, snapshot.data);
            case ConnectionState.done:
              return Center(
                child: Text("Connection closed"),
              );
            default:
              return null; // unreachable
          }
        });
  }

  /// Updates [documentState] (which is in the Widget tree above this Widget) so that bindings
  /// reflect the new data. Then builds using [assembleSections]
  activeBuilder(BuildContext context, DocumentState documentState, Map<String, dynamic> update) {
    documentState.updateData(update);
    return assembleSections(rootBinding: rootBinding, pPage: config);
  }
}
