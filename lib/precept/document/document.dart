import 'package:flutter/material.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/assembler.dart';
import 'package:precept/precept/document/documentController.dart';
import 'package:precept/precept/document/documentState.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

class Document extends StatelessWidget {
  final Stream<DocumentState> documentState;
  final PDocument config;

  Document({Key key, @required this.config})
      : documentState = inject<DocumentController>().getDocument(config.documentSelector),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentState>(
        stream: documentState,
        initialData: DocumentState(),
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
              return activeBuilder(context,  snapshot.data);
            case ConnectionState.done:
              return Center(
                child: Text("Connection closed"),
              );
            default:
              return null; // unreachable
          }
        });
 }

  activeBuilder(BuildContext context, DocumentState documentState) {
    final children=List<Widget>();
    final assembler = inject<PreceptPageAssembler>();
    children.addAll(assembler.assembleElements(elements: config.elements, baseBinding: documentState.rootBinding));
    return ChangeNotifierProvider<SectionState>(create: (_) => SectionState(), child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    ));
  }
}
