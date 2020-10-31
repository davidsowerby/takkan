import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/model/modelDocument.dart';
import 'package:precept/precept/part/string/stringPart.dart';

final testModel = PreceptModel(components: [
  PComponent(
    name: "core",
    routes: [
      PRoute(
          path: "/user/home",
          document: PDocument(
              params: {"id": 234}),
          page: PPage(
            title: "My Home",
            sections: [
              PSection(parts: [PStringPart(property: "name")])
            ],
          ))
    ],
  ),
]);
