import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/style.dart';

final kitchenSinkScript = PScript(
  name: 'test',
  components: {
    'core': PComponent(
      backend: PBackend(backendType: "mock", connection: {'id': 'mock1'}),
      routes: {
        "/": PRoute(
          page: PPage(
            title: "Home Page",
            content: [
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
            ],
          ),
        ),
      },
    )
  },
);
