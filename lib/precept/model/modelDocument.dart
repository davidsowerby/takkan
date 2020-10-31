import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/backend/common/documentIdConverter.dart';
import 'package:precept/common/exceptions.dart';

part 'modelDocument.g.dart';

/// Roughly equivalent to a query with an expected result of one document.
///
/// Specifies how to retrieve a single document in a backend-neutral way
/// Supports various ways of identifying the document:
/// - 'get' with a document id
/// - 'select distinct' with criteria expressed in parameters
/// - 'select first'
/// - 'select last'
@JsonSerializable(nullable: true, explicitToJson: true)
@PDocumentSelectorConverter()
class PDocument {
  final Map<String, dynamic> params;
  final PDocumentSelector selector;

  const PDocument({@required this.params, @required this.selector});

  factory PDocument.fromJson(Map<String, dynamic> json) =>
      _$PDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentToJson(this);
}

/// Retrieves a single document using a [DocumentId]
@JsonSerializable(nullable: true, explicitToJson: true)
class PDocumentGet implements PDocumentSelector {
  final DocumentId id;

  const PDocumentGet({@required this.id});

  factory PDocumentGet.fromJson(Map<String, dynamic> json) =>
      _$PDocumentGetFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentGetToJson(this);
}

/// Used as an interface to identify the classes used to Provide the selection method and criteria for [PDocument]
abstract class PDocumentSelector {}

class PDocumentSelectorConverter
    implements JsonConverter<PDocumentSelector, Map<String, dynamic>> {
  const PDocumentSelectorConverter();

  @override
  PDocumentSelector fromJson(Map<String, dynamic> json) {
    final String typeName = json["type"];
    json.remove("type");
    switch (typeName){
      case "PDocumentGet" : return PDocumentGet.fromJson(json);
      throw PreceptException("Conversion required for $typeName");
    }
  }

  @override
  Map<String, dynamic> toJson(PDocumentSelector object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = Map();
    jsonMap["type"] = type.toString();
    switch (type) {
      case PDocumentGet:
        {
          final PDocumentGet obj = object;
          jsonMap.addAll(obj.toJson());
          return jsonMap;
        }
      default:
        throw PreceptException("Conversion required for $type");
    }
  }
}

/// Standardised document reference, which is converted to / from whatever the cloud provider uses, by an implementation of
/// [DocumentIdConverter].
/// For example, Back4App (ParseServer) uses this as path==className and itemId==objectId
@JsonSerializable(nullable: true, explicitToJson: true)
class DocumentId {
  /// The path to the document, but not including the [itemId]
  final String path;

  final String itemId;

  const DocumentId({@required this.path, @required this.itemId});

  factory DocumentId.fromJson(Map<String, dynamic> json) =>
      _$DocumentIdFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentIdToJson(this);
}
