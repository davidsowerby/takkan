import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'backend.g.dart';

/// Configuration for a [Backend]
///
/// - [instanceName] and [env] serve much the same purpose.  Either can be used as an additional key
/// to lookup from the [BackendLibrary], in order to support multiple instances of the same type.
/// If only a single instance of a type is used (generally the case), neither need to be specified.
/// If both are specified, [instanceName] takes precedence
///
/// [connectionData] is different for each backend implementation, and is therefore just a map.
/// Use this to pass things like connection string, client keys etc
/// This may be redundant if a backend specific sub-class captures properties differently.
///
@JsonSerializable(nullable: true, explicitToJson: true)
class PBackend extends PreceptItem {
  final String instanceName;
  final Map<String, dynamic> connectionData;
  final PScript parent;
  final bool checkHealthOnConnect;
  final Env env;

  PBackend({
    @required String instanceName,
    @required this. env,
    @required this.connectionData,
    this.parent,
    this.checkHealthOnConnect=true,
    String id,
  }) : instanceName = instanceName ?? ((env==null) ? 'default' : env.toString()), super(id: id);

  factory PBackend.fromJson(Map<String, dynamic> json) => _$PBackendFromJson(json);

  Map<String, dynamic> toJson() => _$PBackendToJson(this);

  @override
  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (instanceName == null || instanceName == '') {
      messages.add(ValidationMessage(item: this, msg: 'instanceName cannot be null or empty'));
    }
    if (connectionData == null) {
      messages.add(ValidationMessage(item: this, msg: 'connection cannot be null, but may be empty'));
    }
  }

  doInit(PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(parent, index, useCaptionsAsIds: useCaptionsAsIds);
  }
}

enum Env { dev, test, qa, prod }
enum BackendConnectionState { idle, connecting, connected, failed }
