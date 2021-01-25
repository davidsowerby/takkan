import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/particle/pText.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/style/style.dart';

final kitchenSinkScript = PScript(
  name: 'Kitchen Sink',
  backend: PBackend(instanceName: 'mock', connectionData: {'id': 'mock1'}),
  routes: {
    '/': PRoute(
      page: PPage(
        title: 'Home Page',
        content: [
          PPart(
            isStatic: IsStatic.yes,
            staticData: 'Welcome to the Precept Kitchen Sink, starting with a bit of static text',
            read: PText(showCaption: false),
          ),
          PPanel(
            property: '',
            caption: 'Person',
            help: PHelp(
              title: 'Display options',
              message:
                  'All supported data types are shown.  To demonstrate different display options, some fields are shown multiple times',
            ),
            heading: PPanelHeading(
              style: PHeadingStyle(background: PColor.primary),
            ),
            content: [
              PPart(
                property: 'firstName',
                caption: 'First Name',
              ),
            ],
          ),
        ],
      ),
    ),
  },
);
