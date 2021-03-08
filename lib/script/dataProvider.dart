import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/preceptItem.dart';

part 'dataProvider.g.dart';

/// [headers] specify things like client keys, and is therefore different for each backend implementation.
/// Each implementation must provide the appropriate override.
@JsonSerializable(nullable: true, explicitToJson: true)
class PRestDataProvider extends PDataProvider {
  final String baseUrl;
  final bool checkHealthOnConnect;
  final Map<String, String> headers;

  PRestDataProvider({
    @required PSchema schema,
    this.baseUrl,
    this.checkHealthOnConnect = true,
    String id,
    this.headers = const {},
    Env env,
  }) : super(
          id: id,
          schema: schema,
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

class PDataProvider extends PreceptItem {
  final PSchema schema;

  PDataProvider({
    this.schema,
    String id,
  }) : super(id: id);


}
