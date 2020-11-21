import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/model/modelDocument.dart';

final testModel = PModel(
  components: [
    PComponent(
      name: "core",
      routes: [
        PRoute(
          path: "/",
          page: PPage(
            title: "Home Page",
            document: PDocument(
              documentSelector: PDocumentGet(
                id: DocumentId(path: "any", itemId: "any"),
                params: {},
              ),
            ),
          ),
        ),
      ],
    )
  ],
);
