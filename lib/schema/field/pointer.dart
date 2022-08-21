// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import '../../common/constants.dart';

import '../../data/object/pointer.dart';
import 'field.dart';

part 'pointer.g.dart';

@JsonSerializable(explicitToJson: true)
class FPointer extends Field<Pointer> {
  FPointer({
    required this.targetClass,
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FPointer.fromJson(Map<String, dynamic> json) =>
      _$FPointerFromJson(json);

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [...super.props, targetClass];

  @override
  Type get modelType => Pointer;
  final String targetClass;

  @override
  Map<String, dynamic> toJson() => _$FPointerToJson(this);
}
