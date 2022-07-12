// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]

import 'package:json_annotation/json_annotation.dart';

import '../../script/script_element.dart';
import '../schema.dart';
import 'field.dart';
import 'list.dart';

part 'query_result.g.dart';

/// A [FQuerySchema] is very similar to a [FList], except there is no facility to specify
/// validations (as it is not appropriate to run validation on the results of a data-select)
///
/// [documentSchema] is used to lookup the schema for the document(s) returned, from [Schema.documents]
///
/// [permissions] can be defined but usually permissions are set by the [documentSchema]
@Deprecated('https://gitlab.com/takkan/takkan_script/-/issues/43')
@JsonSerializable(explicitToJson: true)
class FQuerySchema extends Field< List<dynamic>> {

  @Deprecated('https://gitlab.com/takkan/takkan_script/-/issues/43')
  FQuerySchema({
    required this.documentSchema,
  }) : super(
          required: false,
          readOnly: IsReadOnly.yes,
        );

  @Deprecated('https://gitlab.com/takkan/takkan_script/-/issues/43')
  factory FQuerySchema.fromJson(Map<String, dynamic> json) =>
      _$FQuerySchemaFromJson(json);
  final String documentSchema;

  @override
  Map<String, dynamic> toJson() => _$FQuerySchemaToJson(this);
  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [...super.props,documentSchema];
  @override
  Type get modelType => List;
}
