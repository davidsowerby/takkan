import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/signin/signIn.dart';
import 'package:precept_script/validation/message.dart';

part 'dataProviderBase.g.dart';

/// Either [schema] or [schemaSource] can be set.
///
/// [schema] can be set directly during development, [schemaSource] is required for production use.
///
/// If [schema] is not set, it is loaded on demand from the configuration specified by [schemaSource]
/// The presence of [schema] should therefore be tested before using it.
///

abstract class PDataProviderBase extends PreceptItem {
  final PSignInOptions signInOptions;
  final PSignIn signIn;
  final PConfigSource configSource;

  @JsonKey(ignore: true)
  PSchema _schema;
  final PSchemaSource? schemaSource;
  final bool checkHealthOnConnect;
  final String sessionTokenKey;
  final List<String> headerKeys;
  final String documentEndpoint;

  @JsonKey(ignore: true)
  PSchema? get schema => _schema;

  set schema(value) => _schema = value;

  PDataProviderBase({
    required this.headerKeys,
    required this.documentEndpoint,
    required this.sessionTokenKey,
    required this.configSource,
    this.checkHealthOnConnect = false,
    required this.signInOptions,
    PSchema? schema,
    this.schemaSource,
    required this.signIn,
    String? id,
  })  : _schema = schema!,
        super(id: id);

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (schema == null && schemaSource == null) {
      messages.add(ValidationMessage(
          item: this, msg: "Either 'schema' or 'schemaSource' must be specified"));
    }
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (schemaSource != null) schemaSource?.walk(visitors);
  }

  /// This can be overridden, because Back4App for example, uses the objectId field value
  String get idPropertyName => 'id';
}

/// [segment] and [instance] together define which part **precept.json** is used to
/// configure a [DataProvider] connection
@JsonSerializable(explicitToJson: true)
class PConfigSource {
  final String segment;
  final String instance;

  const PConfigSource({required this.segment, required this.instance});

  @override
  String toString() {
    return '$segment:$instance';
  }

  factory PConfigSource.fromJson(Map<String, dynamic> json) => _$PConfigSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PConfigSourceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PNoDataProvider extends PDataProviderBase {
  PNoDataProvider()
      : super(
          documentEndpoint: '',
          signInOptions: const PSignInOptions(),
          signIn: const PSignIn(),
          headerKeys: const [],
          configSource: PConfigSource(segment: 'none', instance: 'none'),
          schemaSource: PSchemaSource(segment: 'none', instance: 'none'),
          sessionTokenKey: 'No Data Provider',
        );

  factory PNoDataProvider.fromJson(Map<String, dynamic> json) => _$PNoDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PNoDataProviderToJson(this);
}
