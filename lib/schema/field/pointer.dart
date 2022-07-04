import 'package:json_annotation/json_annotation.dart';

import '../../data/object/pointer.dart';
import '../../script/common.dart';
import 'field.dart';

part 'pointer.g.dart';

@JsonSerializable(explicitToJson: true)
class FPointer extends Field< Pointer> {

  FPointer({
    required this.targetClass,
    super.defaultValue,
    super. constraints = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
    super.validation,
  }) ;

  factory FPointer.fromJson(Map<String, dynamic> json) =>
      _$FPointerFromJson(json);
  @override
  Type get modelType => Pointer;
  final String targetClass;

  @override
  Map<String, dynamic> toJson() => _$FPointerToJson(this);
}
