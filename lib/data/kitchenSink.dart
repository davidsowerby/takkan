
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/style.dart';

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
              caption: "Person",
              help: PHelp(
                title: "Display options",
                message:
                    'All supported data types are shown.  To demonstrate different display options, some fields are shown multiple times',
              ),
              heading: PPanelHeading(
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
