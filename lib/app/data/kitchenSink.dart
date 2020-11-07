import 'package:precept/precept/model/help.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/model/style.dart';
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
                      property: "text",
                      help: PHelp(
                        title: "Text",
                        message: "This sections shows StringPart and StaticText",
                      ),
                      heading: PSectionHeading(
                        title: "Text",
                        style: PHeadingStyle(background: PColor.primary),
                      ),
                      elements: [
                        PString(
                          property: "stringPart",
                          caption: "StringPart",
                        ),
                        PStaticText(text: "This is static text which cannot be edited, but you can change the style", caption: "StaticText")
                      ],
                    ),
                    PSection(
                      caption: "Section 2",
                      property: "section2",
                      elements: [
                        PString(property: "name", caption: "Name"),
                        PString(property: "preference", caption: "Preference"),
                      ],
                    )
                  ]),
            ],
          ),
        ),
      ],
    )
  ],
);
