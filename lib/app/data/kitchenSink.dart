import 'package:precept_client/app/data/schema.dart';
import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:precept_client/precept/script/backend.dart';
import 'package:precept_client/precept/script/document.dart';
import 'package:precept_client/precept/script/help.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:precept_client/precept/script/style.dart';

final kitchenSinkScript = PScript(
  components: [
    PComponent(
      backend: PBackend(backendKey: "mock", connection: {'id': 'mock1'}),
      name: "core",
      routes: [
        PRoute(
          path: "/",
          page: PPage(
            title: "Home Page",
            document: PDocument(
                schema: schema.components["core"].documents["sink"],
                documentSelector: PDocumentGet(
                  id: DocumentId(path: "any", itemId: "any"),
                  params: {},
                ),
                sections: [
                  PSection(
                    property: "",
                    help: PHelp(
                      title: "Display options",
                      message:
                          'All supported data types are shown.  To demonstrate different display options, some fields are shown multiple times',
                    ),
                    heading: PSectionHeading(
                      title: "Person",
                      style: PHeadingStyle(background: PColor.primary),
                    ),
                    content: [
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
