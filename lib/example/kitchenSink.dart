import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/trait/style.dart';

final kitchenSinkScript = PScript(
  name: 'Kitchen Sink',
  dataProvider: PRestDataProvider(
    configSource: PConfigSource(
      segment: 'back4app',
      instance: 'dev',
    ),
  ),
  pages: {
    '/': PPage(
        title: 'Home Page',
        content: [
          PText(
            isStatic: IsStatic.yes,
            staticData: 'Welcome to the Precept Kitchen Sink, starting with a bit of static text',
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
              PPart(readTraitName: 'part',
                property: 'firstName',
                caption: 'First Name',
              ),
            ],
          ),
        ],
      ),
  },
);

final kitchenSinkScriptWithoutDataProvider = PScript(
  name: 'Kitchen Sink',
  pages: {
    '/': PPage(
        title: 'Home Page',
        content: [
          PPart(readTraitName: 'part',
            isStatic: IsStatic.yes,
            staticData: 'Welcome to the Precept Kitchen Sink, starting with a bit of static text',
            // readTraitName: PText(showCaption: false),
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
              PPart(readTraitName: 'part',
                property: 'firstName',
                caption: 'First Name',
              ),
            ],
          ),
        ],
      ),
  },
);
