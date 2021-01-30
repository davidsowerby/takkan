import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/backend.dart';

part 'pBack4AppBackend.g.dart';

/// When [debug] enabled, prints logs to console
@JsonSerializable(nullable: true, explicitToJson: true)
class PBack4AppBackend extends PBackend {
  final bool debug;

  PBack4AppBackend({
    this.debug = true,
    String instanceName,
    Env env,
    bool checkHealthOnConnect,
  }) : super(instanceName: instanceName, env: env, connectionData: {},checkHealthOnConnect: checkHealthOnConnect);

  factory PBack4AppBackend.fromJson(Map<String, dynamic> json) => _$PBack4AppBackendFromJson(json);

  Map<String, dynamic> toJson() => _$PBack4AppBackendToJson(this);
}
