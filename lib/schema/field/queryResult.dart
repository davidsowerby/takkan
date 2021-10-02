import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/list.dart';
import 'package:precept_script/schema/schema.dart';

part 'queryResult.g.dart';

/// A [PQuerySchema] is very similar to a [PList], except there is no facility to specify
/// validations (as it is not appropriate to run validation on the results of a query)
///
/// [documentSchema] is used to lookup the schema for the document(s) returned, from [PSchema.documents]
///
/// [permissions] can be defined but usually permissions are set by the [documentSchema]
@JsonSerializable(explicitToJson: true)
class PQuerySchema extends PField<ListValidation, List> {
  final String documentSchema;

  PQuerySchema({
    required this.documentSchema,
  }) : super(
          required: false,
          readOnly: IsReadOnly.yes,
        );

  factory PQuerySchema.fromJson(Map<String, dynamic> json) =>
      _$PQuerySchemaFromJson(json);

  Map<String, dynamic> toJson() => _$PQuerySchemaToJson(this);

  @override
  Type get modelType => List;
}
