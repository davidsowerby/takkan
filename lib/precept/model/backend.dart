import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'backend.g.dart';


/// Configuration for a [Backend]
///
/// The [connection] will be different for each backend, and is therefore just a map.  Use this to pass things
/// like connection string, client keys etc
///
/// A [Backend] implementation should explicitly declare what is required
@JsonSerializable(nullable: true, explicitToJson: true)
class PBackend {
  final String backendKey;
  final Map<String, dynamic> connection;

  const PBackend({@required this.backendKey, @required this.connection});

  factory PBackend.fromJson(Map<String, dynamic> json) => _$PBackendFromJson(json);

  Map<String, dynamic> toJson() => _$PBackendToJson(this);
}
