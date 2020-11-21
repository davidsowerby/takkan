import 'package:precept/app/data/targetSchema.dart';
import 'package:precept/precept/model/help.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/model/style.dart';
import 'package:precept/precept/part/string/stringPart.dart';

final kitchenSinkModel = PModel(
  components: [
    PComponent(
      name: "core",
      routes: [
        PRoute(
          path: "/",
          page: PPage(
            title: "Home Page",
            document:
              PDocument(schema: schema.core.sink,
                  documentSelector: PDocumentGet(
                    id: DocumentId(path: "any", itemId: "any"),
                    params: {},
                  ),
                  sections: [
                    PSection(
                      schema: schema.core.sink,
                      help: PHelp(
                        title: "Display of String data",
                        message: 'This section shows StringPart and StaticText, with various display options applied',
                      ),
                      heading: PSectionHeading(
                        title: "String data",
                        style: PHeadingStyle(background: PColor.primary),
                      ),
                      elements: [
                        PString(
                          schema: schema.core.sink.brand,
                          caption: "StringPart with default settings",
                        ),
                        PStaticText(text: "This is static text which cannot be edited.", caption: "StaticText")
                      ],
                    ),

                  ]),

          ),
        ),
      ],
    )
  ],
);
