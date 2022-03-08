import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/script/version.dart';

final myScript = PScript(
  name: 'Tutorial',
  version: const PVersion(number: 0),
  routes: {
    '/': PPage(
      title: 'Home Page',
      content: [
        PText(
          readTraitName: PText.title,
          isStatic: IsStatic.yes,
          staticData: 'Precept',
        ),
      ],
    ),
  },
  schema: PSchema(
    name: 'Tutorial Schema',
    version: const PVersion(number: 0),
  ),
);
