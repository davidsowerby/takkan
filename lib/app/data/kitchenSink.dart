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
                        message: "This section shows StringPart and StaticText, with various styling options applied.\n\nNot all options are shown, though",
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
                        PStaticText(text: "This is static text which cannot be edited.", caption: "StaticText")
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
