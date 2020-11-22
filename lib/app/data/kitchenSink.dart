
import 'package:precept_client/app/data/schema.dart';
import 'package:precept_client/precept/model/help.dart';
import 'package:precept_client/precept/model/model.dart';
import 'package:precept_client/precept/model/modelDocument.dart';
import 'package:precept_client/precept/model/style.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
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
              PDocument(schema: schema.components["core"].documents["sink"],
                  documentSelector: PDocumentGet(
                    id: DocumentId(path: "any", itemId: "any"),
                    params: {},
                  ),
                  sections: [
                    PSection(
                      property:"",
                      help: PHelp(
                        title: "Display options",
                        message: 'All supported data types are shown.  To demonstrate different display options, some fields are shown multiple times',
                      ),
                      heading: PSectionHeading(
                        title: "Person",
                        style: PHeadingStyle(background: PColor.primary),
                      ),
                      elements: [
                        PStaticText(text: "You can use static text like this", caption: "StaticText"),
                        PStaticText(text: "All text should be pre-translated patterns"),
                        PString(
                          property: "firstName",
                          caption: "First Name",
                        ),

                      ],
                    ),

                  ]),

          ),
        ),
      ],
    )
  ],
);
