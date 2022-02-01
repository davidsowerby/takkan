import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/query/query.dart';

part 'rest_query.g.dart';

/// A query that is executed using a REST client. Currently only supports a
/// REST API which takes query parameters as part of the path ([paramsAsPath]=true).
///
/// [path] is not usually required, certainly not for Back4App, and uses the
/// [documentSchema], which is the document type defined within [PSchema.documents]
///
/// [queryName] see [PQuery.queryName]
@JsonSerializable(explicitToJson: true)
class PRestQuery extends PQuery {
  final bool paramsAsPath;
  final Map<String, String> params;
  final String? _path;

  PRestQuery({
    String? path,
    Map<String, dynamic> variables = const {},
    List<String> propertyReferences = const [],
    this.paramsAsPath = true,
    required String queryName,
    required String documentSchema,
    this.params = const {},
    QueryReturnType returnType = QueryReturnType.futureList,
  })  : _path = path,
        super(
          propertyReferences: propertyReferences,
          variables: variables,
          documentSchema: documentSchema,
          queryName: queryName,
          returnType: returnType,
        );

  String get path => _path ?? documentSchema;

  factory PRestQuery.fromJson(Map<String, dynamic> json) =>
      _$PRestQueryFromJson(json);

  Map<String, dynamic> toJson() => _$PRestQueryToJson(this);
}
