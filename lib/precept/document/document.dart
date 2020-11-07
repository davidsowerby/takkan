import 'package:flutter/material.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/assembler.dart';
import 'package:precept/precept/document/documentController.dart';
import 'package:precept/precept/document/documentState.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

class Document extends StatelessWidget {
  final Stream<Map<String,dynamic>> documentDataStream;
  final PDocument config;

  Document({Key key, @required this.config})
      : documentDataStream = inject<DocumentController>().getDocument(config.documentSelector),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final DocumentState documentState = Provider.of<DocumentState>(context);
    return StreamBuilder<Map<String,dynamic>>(
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
  /// reflect the new data. Then builds using a [PreceptPageAssembler]
  activeBuilder(BuildContext context, DocumentState documentState, Map<String,dynamic> update) {
    documentState.updateData(update);
    final children = List<Widget>();
    final assembler = inject<PreceptPageAssembler>();
    children.addAll(assembler.assembleElements(
        elements: config.elements, baseBinding: documentState.rootBinding));
    return ChangeNotifierProvider<SectionState>(
        create: (_) => SectionState(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ));
  }
}
