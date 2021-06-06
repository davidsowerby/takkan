import 'package:precept_script/query/query.dart';

class PRestQuery extends PQuery {
  final bool paramsAsPath;
  final Map<String, String> params;

  PRestQuery({
    this.paramsAsPath = true,
    required String querySchema,
    this.params = const {},
    QueryReturnType returnType = QueryReturnType.futureList,
  }) : super(
          querySchema: querySchema,
          returnType: returnType,
        );
}
