
import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable(explicitToJson: true)
class TakkanError {

  const TakkanError({required this.message});

  factory TakkanError.fromJson(Map<String, dynamic> json) =>
      _$TakkanErrorFromJson(json);
  final String message;

  Map<String, dynamic> toJson() => _$TakkanErrorToJson(this);
}
