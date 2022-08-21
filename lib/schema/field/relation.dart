// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import '../../common/constants.dart';

import '../../data/object/relation.dart';
import 'field.dart';

part 'relation.g.dart';

@JsonSerializable(explicitToJson: true)
class FRelation extends Field<Relation> {
  FRelation({
    required this.targetClass,
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FRelation.fromJson(Map<String, dynamic> json) =>
      _$FRelationFromJson(json);

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [...super.props, targetClass];

  @override
  Type get modelType => Relation;
  final String targetClass;

  @override
  Map<String, dynamic> toJson() => _$FRelationToJson(this);
}
