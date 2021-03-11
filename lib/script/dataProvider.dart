import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/script/visitor.dart';
import 'package:precept_script/validation/message.dart';

part 'dataProvider.g.dart';

/// [headers] specify things like client keys, and is therefore different for each backend implementation.
/// Each implementation must provide the appropriate override.
@JsonSerializable(nullable: true, explicitToJson: true)
class PRestDataProvider extends PDataProvider {
  final String baseUrl;
  final bool checkHealthOnConnect;
  final Map<String, String> headers;

  PRestDataProvider({
    PSchemaSource schemaSource,
    PSchema schema,
    this.baseUrl,
    this.checkHealthOnConnect = true,
    String id,
    this.headers = const {},
    Env env,
  }) : super(
          id: id,
          schema: schema,
          schemaSource: schemaSource,
        );

  factory PRestDataProvider.fromJson(Map<String, dynamic> json) =>
      _$PRestDataProviderFromJson(json);

  Map<String, dynamic> toJson() => _$PRestDataProviderToJson(this);

  String get documentBaseUrl => baseUrl;

  String documentUrl(DocumentId documentId) {
    return '$documentBaseUrl/${documentId.path}/${documentId.itemId}';
  }
}

enum Env { dev, test, qa, prod }

/// Either [schema] or [schemaSource] can be set.
/// If [schema] is not set, it is loaded on demand from the configuration specified by [schemaSource]
@JsonSerializable(nullable: true, explicitToJson: true)
class PDataProvider extends PreceptItem {
  @JsonKey(ignore: true)
  PSchema _schema;
  final PSchemaSource schemaSource;

  @JsonKey(ignore: true)
  PSchema get schema => _schema;

  set schema(value) => _schema = value;

  PDataProvider({
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

  walk(List<ScriptVisitor> visitors){
    super.walk(visitors);
    if(schemaSource != null) schemaSource.walk(visitors);
  }
}
