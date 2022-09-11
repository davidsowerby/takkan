// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../data/select/condition/string_condition.dart';
import 'field.dart';

part 'file.g.dart';

@JsonSerializable(explicitToJson: true)
class FFile extends Field<String, StringCondition> {
  FFile({
    super.defaultValue,
    super.constraints = const [],
    super.required = false,
    super.isReadOnly = IsReadOnly.inherited,
    super.validation,
  });

  factory FFile.fromJson(Map<String, dynamic> json) => _$FFileFromJson(json);

  @override
  Type get modelType => File;

  @override
  Map<String, dynamic> toJson() => _$FFileToJson(this);
}
