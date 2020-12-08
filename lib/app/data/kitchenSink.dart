import 'package:precept_client/precept/part/string/stringPart.dart';
import 'package:precept_client/precept/script/backend.dart';
import 'package:precept_client/precept/script/help.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:precept_client/precept/script/style.dart';

final kitchenSinkScript = PScript(
  components: [
    PComponent(
      backend: PBackend(backendType: "mock", connection: {'id': 'mock1'}),
      name: "core",
      routes: [
        PRoute(
          path: "/",
          page: PPage(title: "Home Page", content: [
            PPanel(
              property: "",
              help: PHelp(
                title: "Display options",
                message:
                    'All supported data types are shown.  To demonstrate different display options, some fields are shown multiple times',
              ),
              heading: PPanelHeading(
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
      ],
    )
  ],
);
