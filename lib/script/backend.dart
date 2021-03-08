import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/script/signIn.dart';
import 'package:precept_script/validation/message.dart';

part 'backend.g.dart';

/// The [schema] is passed to a [PDataProvider] created by the backend-specific implementation
///
/// - [instanceName] and [env] serve much the same purpose.  Either can be used a key
/// to look up config from *precept.json*, in order to support
/// multiple instances of the same type. If only a single instance of a type is used, neither need
/// to be specified and a value of 'default' is used. If both are specified, [instanceName] takes precedence
///
/// This may be specified directly, or loaded using [loadConfig]
///
/// If [configFilePath] is specified, [loadConfig] is invoked by [doInit], and should normally override
/// directly declared declare entries - however this may be done differently in different implementations.
///
///
@JsonSerializable(nullable: true, explicitToJson: true)
class PBackend extends PreceptItem {
  final String instanceName;
  final PSchema schema;
  final Env env;
  final PSignInOptions signInOptions;

  PBackend({String instanceName,this.schema,this.env, String id, this.signInOptions}) : instanceName = instanceName ?? ((env == null) ? 'default' : env.toString().substring(4)),
    super(id: id);

  factory PBackend.fromJson(Map<String, dynamic> json) =>
      _$PBackendFromJson(json);

  Map<String, dynamic> toJson() => _$PBackendToJson(this);

  @override
  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (instanceName == null || instanceName == '') {
      messages.add(ValidationMessage(item: this, msg: 'instanceName cannot be null or empty'));
    }
  }
}