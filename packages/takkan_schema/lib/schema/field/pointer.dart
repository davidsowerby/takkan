// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import '../../common/constants.dart';

import '../../data/object/pointer.dart';
import '../../data/select/condition/pointer_condition.dart';
import 'field.dart';

part 'pointer.g.dart';

@JsonSerializable(explicitToJson: true)
class FPointer extends Field<Pointer, PointerCondition> {
  FPointer({
    required this.targetClass,
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FPointer.fromJson(Map<String, dynamic> json) =>
      _$FPointerFromJson(json);

 @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [...super.props, targetClass];

  @override
  Type get modelType => Pointer;
  final String targetClass;

  @override
 @JsonKey(includeToJson: false, includeFromJson: false)
  bool get isLinkField => true;

  @override
  Map<String, dynamic> toJson() => _$FPointerToJson(this);
}
