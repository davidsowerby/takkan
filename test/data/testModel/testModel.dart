import 'package:precept/pc/pc.dart';

final testModel = Precept(components: [
  PComponent(
    name: "core",
    routes: [
      PRoute(
          path: "/user/home",
          page: PPage(
            title: "My Home",
            sections: [
              PSection(parts: [PStringPart(property: "name")])
            ],
          ))
    ],
  ),
]);
