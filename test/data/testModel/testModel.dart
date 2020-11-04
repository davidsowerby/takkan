import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/part/string/stringPart.dart';

final testModel = PreceptModel(
  components: [
    PComponent(
      name: "core",
      routes: [
        PRoute(
          path: "/",
          page: PPage(
            title: "Home Page",
            sections: [
              PDocumentSection(
                documentSelector: PDocumentGet(
                  id: DocumentId(path: "any", itemId: "any"),
                  params: {},
                ),
              ),
            ],
          ),
        ),
      ],
    )
  ],
);

