import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/list.dart';
import 'package:precept_script/schema/schema.dart';

part 'queryResult.g.dart';

/// A [QueryResult] is very similar to a [PList], but it is not appropriate to run validation
/// against a query result.
///
/// [permissions] can be defined but usually permissions are set by the schema of the result
/// 'documents'
@JsonSerializable( explicitToJson: true)
class PQueryResult extends PField<ListValidation, List> {
  PQueryResult({
    PPermissions permissions = const PPermissions(),
  }) : super(permissions: permissions);

  factory PQueryResult.fromJson(Map<String, dynamic> json) => _$PQueryResultFromJson(json);

  Map<String, dynamic> toJson() => _$PQueryResultToJson(this);

  @override
  bool doValidation(validation, List<dynamic> value) {
    throw PreceptException('A query cannot be validated');
  }

  @override
  Type get modelType => List;
}
