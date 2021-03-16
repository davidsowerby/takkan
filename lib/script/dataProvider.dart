import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/script/signIn.dart';
import 'package:precept_script/script/visitor.dart';
import 'package:precept_script/validation/message.dart';

part 'dataProvider.g.dart';

/// [headers] specify things like client keys, and is therefore different for each backend implementation.
/// Each implementation must provide the appropriate override.
@JsonSerializable(nullable: true, explicitToJson: true)
class PRestDataProvider extends PDataProvider {
  final String serverUrl;
  final bool checkHealthOnConnect;
  final Map<String, String> headers;

  PRestDataProvider({
    PSchemaSource schemaSource,
    PSchema schema,
    this.serverUrl,
    this.checkHealthOnConnect = true,
    String id,
    this.headers = const {},
    PConfigSource configSource,
  }) : super(
          id: id,
          schema: schema,
          schemaSource: schemaSource,
          configSource: configSource,
        );

  factory PRestDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PRestDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PRestDataProviderToJson(this);

  String get documentBaseUrl => serverUrl;

  String documentUrl(DocumentId documentId) {
    return '$documentBaseUrl/${documentId.path}/${documentId.itemId}';
  }
}

/// Either [schema] or [schemaSource] can be set.
///
/// [schema] can be set directly during development, [schemaSource] is required for production use.
///
/// If [schema] is not set, it is loaded on demand from the configuration specified by [schemaSource]
/// The presence of [schema] should therefore be tested before using it.
///

@JsonSerializable(nullable: true, explicitToJson: true)
class PDataProvider extends PreceptItem {
  final PSignInOptions signInOptions;
  final PConfigSource configSource;
  @JsonKey(ignore: true)
  PSchema _schema;
  final PSchemaSource schemaSource;

  @JsonKey(ignore: true)
  PSchema get schema => _schema;

  set schema(value) => _schema = value;

  PDataProvider({
    @required this.configSource,
    this.signInOptions = const PSignInOptions(),
    PSchema schema,
    this.schemaSource,
    String id,
  }) : super(id: id);

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (schema == null && schemaSource == null) {
      messages.add(ValidationMessage(
          item: this, msg: "Either 'schema' or 'schemaSource' must be specified"));
    }
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (schemaSource != null) schemaSource.walk(visitors);
  }
}

/// [segment] and [instance] together define which part **precept.json** is used to
/// configure a [DataProvider] connection
@JsonSerializable(nullable: true, explicitToJson: true)
class PConfigSource {
  final String segment;
  final String instance;

  const PConfigSource({@required this.segment, @required this.instance});

  factory PConfigSource.fromJson(Map<String, dynamic> json) => _$PConfigSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PConfigSourceToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PNoDataProvider extends PDataProvider {
  PNoDataProvider()
      : super(
          configSource: PConfigSource(segment: 'none', instance: 'none'),
          schemaSource: PSchemaSource(segment: 'none', instance: 'none'),
        );

  factory PNoDataProvider.fromJson(Map<String, dynamic> json) => _$PNoDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PNoDataProviderToJson(this);
}


