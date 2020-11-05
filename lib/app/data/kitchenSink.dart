import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/part/string/stringPart.dart';

final kitchenSinkModel = PreceptModel(
  components: [
    PComponent(
      name: "core",
      routes: [
        PRoute(
          path: "/",
          page: PPage(
            title: "Home Page",
            elements: [
              PDocument(
                  documentSelector: PDocumentGet(
                    id: DocumentId(path: "any", itemId: "any"),
                    params: {},
                  ),
                  elements: [
                    PString(
                      property: "title",
                      caption: "Title",
                    ),
                    PSection(
                      property: "stuff",
                        heading: PSectionHeading(title: "Section 1"),
                        elements: [
                          PString(
                            property: "value",
                            caption: "Value",
                          ),
                        ]),
                  ]),
            ],
          ),
        ),
      ],
    )
  ],
);
