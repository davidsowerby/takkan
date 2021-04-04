import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PError {
  final String message;

  const PError({@required this.message});

  factory PError.fromJson(Map<String, dynamic> json) => _$PErrorFromJson(json);

  Map<String, dynamic> toJson() => _$PErrorToJson(this);
}
