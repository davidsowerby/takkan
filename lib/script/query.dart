import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/validation/message.dart';

part 'query.g.dart';

/// Roughly equivalent to a query with an expected result of one document, or a List of documents
/// as either a Future or a Stream. Implementations are in broad categories of 'get',
/// Specifies how to retrieve a single document or a list of documents in a backend-neutral way
/// Supports various ways of identifying the document:
/// - 'get' with a document id
/// - 'select distinct' with criteria expressed in parameters
/// - 'select first'
/// - 'select last'
///
/// [document] is usually the equivalent of something like a table name, and does not usually need to be specified
/// explicitly - it is typically derived from whatever is used to select the required data
///
///
abstract class PQuery extends PreceptItem {
  String get document;

  PQuery({this.params});

  final Map<String, dynamic> params;

  void doValidate(List<ValidationMessage> messages, {int index = -1}) {}
}

/// Retrieves a single document using a [DocumentId]
@JsonSerializable(nullable: true, explicitToJson: true)
class PGet extends PQuery {
  final DocumentId documentId;

  PGet({
    @required this.documentId,
    Map<String, dynamic> params = const {},
  }) : super(
    params: params,
  );

  factory PGet.fromJson(Map<String, dynamic> json) => _$PGetFromJson(json);

  Map<String, dynamic> toJson() => _$PGetToJson(this);

  String get document => documentId.path;

  @override
  void doValidate(List<ValidationMessage> messages, {int index = -1}) {
    if (documentId == null) {
      messages.add(ValidationMessage(item: this, msg: "PDataGet must define a documentId"));
    }
  }

// DataSourceReturn get returnType=> throw PreceptException('returnType This must ')
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PGetStream extends PQuery {
  final DocumentId documentId;

  PGetStream({
    @required this.documentId,
    Map<String, dynamic> params = const {},
  }) : super(
    params: params,
  );

  String get document => documentId.path;

  factory PGetStream.fromJson(Map<String, dynamic> json) => _$PGetStreamFromJson(json);

  Map<String, dynamic> toJson() => _$PGetStreamToJson(this);
}

enum DataSourceReturn { future, futureList, stream, streamList }
