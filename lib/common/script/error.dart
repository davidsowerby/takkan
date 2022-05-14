
import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable(explicitToJson: true)
class Lamin8Error {
  final String message;

  const Lamin8Error({required this.message});

  factory Lamin8Error.fromJson(Map<String, dynamic> json) =>
      _$Lamin8ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$Lamin8ErrorToJson(this);
}
