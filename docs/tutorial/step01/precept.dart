import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/part/text.dart';


final myScript = PScript(
  name: 'Tutorial',
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
);