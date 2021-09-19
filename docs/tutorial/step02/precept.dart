import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/part/navigation.dart';


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
        PText(
          readTraitName: PText.subtitle,
          isStatic: IsStatic.yes,
          staticData: 'Proof of Concept',
        ),
        PText(
          readTraitName: PText.strapText,
          isStatic: IsStatic.yes,
          staticData: 'A brief introduction to faster Flutter development',
        ),
        PNavButton(
          isStatic: IsStatic.yes,
          staticData: 'OK',
          route: 'chooseList',
        ),
      ],
    ),
  },
);