import 'package:json_annotation/json_annotation.dart';

part 'restDelegate.g.dart';

/// Sensitive keys - such as API Keys - are held in **precept.json** in the project root directory.
/// [headerKeys], in conjunction with [configSource], are used to look these keys from **precept.json**.
///
/// Key names may be different for each backend implementation.
///
/// Even if there is no requirement for an API key (usually true only for open public APIs),
/// [configSource] must still be specified
///
/// [serverUrl]
@JsonSerializable(explicitToJson: true)
class PRestDelegate {
  final bool checkHealthOnConnect;
  final String documentEndpoint;
  final String sessionTokenKey;
  final List<String> headerKeys;

  PRestDelegate({
    required this.documentEndpoint,
    this.checkHealthOnConnect = false,
    required this.sessionTokenKey,
    required this.headerKeys,
  });

  factory PRestDelegate.fromJson(Map<String, dynamic> json) =>
      _$PRestDelegateFromJson(json);

  Map<String, dynamic> toJson() => _$PRestDelegateToJson(this);
}
