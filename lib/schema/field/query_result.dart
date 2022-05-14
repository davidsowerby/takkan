import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/list.dart';
import 'package:precept_script/schema/schema.dart';

part 'query_result.g.dart';

/// A [FQuerySchema] is very similar to a [FList], except there is no facility to specify
/// validations (as it is not appropriate to run validation on the results of a data-select)
///
/// [documentSchema] is used to lookup the schema for the document(s) returned, from [Schema.documents]
///
/// [permissions] can be defined but usually permissions are set by the [documentSchema]
@deprecated
@JsonSerializable(explicitToJson: true)
class FQuerySchema extends Field<ListValidation, List> {
  final String documentSchema;

  FQuerySchema({
    required this.documentSchema,
  }) : super(
          required: false,
          readOnly: IsReadOnly.yes,
        );

  factory FQuerySchema.fromJson(Map<String, dynamic> json) =>
      _$FQuerySchemaFromJson(json);

  Map<String, dynamic> toJson() => _$FQuerySchemaToJson(this);

  @override
  Type get modelType => List;
}
