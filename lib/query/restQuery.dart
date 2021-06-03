import 'package:precept_script/query/query.dart';

class PRestQuery extends PQuery {
  final bool paramsAsPath;
  final Map<String, String> params;

  PRestQuery({this.paramsAsPath = true, required String name, this.params = const {}})
      : super(name: name, returnType: QueryReturnType.futureList);

  @override
  String get table => name;
}
