import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/string/stringPart.dart';

final kitchenSinkModel = PreceptModel(components: [
  PComponent(
    name: "core",
    routes: [
      PRoute(
          path: "/",
          page: PPage(
            title: "Home",
            sections: [
              PSection(parts: [PStringPart(property: "name")])
            ],
          ))
    ],
  ),
]);
