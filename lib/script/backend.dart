import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/script.dart';
part 'backend.g.dart';


/// Configuration for a [BackendHandler]
///
/// - [backendType] is used as a key to lookup from the [BackendLibrary]. Unless you change the defaults,
/// 'mock' is always available
///
/// The [connection] will be different for each backend, and is therefore just a map.  Use this to pass things
/// like connection string, client keys etc
///
/// A [BackendDelegate] implementation should explicitly declare what is required
@JsonSerializable(nullable: true, explicitToJson: true)
class PBackend {
  final String backendType;
  final Map<String, dynamic> connection;
  final PScript parent;

  const PBackend({@required this.backendType, @required this.connection, this.parent});

  factory PBackend.fromJson(Map<String, dynamic> json) => _$PBackendFromJson(json);

  Map<String, dynamic> toJson() => _$PBackendToJson(this);
}



