import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/query/query.dart';

part 'restQuery.g.dart';

@JsonSerializable(explicitToJson: true)
class PRestQuery extends PQuery {
  final bool paramsAsPath;
  final Map<String, String> params;

  PRestQuery({
    this.paramsAsPath = true,
    required String querySchemaName,
    this.params = const {},
    QueryReturnType returnType = QueryReturnType.futureList,
  }) : super(
    querySchemaName: querySchemaName,
          returnType: returnType,
        );

  factory PRestQuery.fromJson(Map<String, dynamic> json) =>
      _$PRestQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PRestQueryToJson(this);
}