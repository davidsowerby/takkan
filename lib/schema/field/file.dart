// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../data/select/condition/condition.dart';
import '../../script/script_element.dart';
import 'field.dart';

part 'file.g.dart';

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class FFile extends Field< String> {
  FFile({
    super. defaultValue,
    super.constraints = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
    super.validation,
  }) ;

  factory FFile.fromJson(Map<String, dynamic> json) => _$FFileFromJson(json);

  @override
  Type get modelType => File;

  @override
  Map<String, dynamic> toJson() => _$FFileToJson(this);
}
