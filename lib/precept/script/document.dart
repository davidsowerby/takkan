import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/precept/script/script.dart';

part 'document.g.dart';

/// Roughly equivalent to a query with an expected result of one document.
///
/// Specifies how to retrieve a single document in a backend-neutral way
/// Supports various ways of identifying the document:
/// - 'get' with a document id
/// - 'select distinct' with criteria expressed in parameters
/// - 'select first'
/// - 'select last'

/// Classes used to define selection method and criteria for a document
abstract class PDocumentSelector extends PCommon{
  final Map<String, dynamic> params;
  @JsonKey(ignore: true)
  PDocument _parent;
   PDocumentSelector({@required this.params});

  void validate( List<ValidationMessage> messages, int pass);
}

/// Retrieves a single document using a [DocumentId]
@JsonSerializable(nullable: true, explicitToJson: true)
class PDocumentGet extends PDocumentSelector {
  final DocumentId id;

   PDocumentGet({@required this.id, @required Map<String, dynamic> params})
      : super(params: params);

  factory PDocumentGet.fromJson(Map<String, dynamic> json) =>
      _$PDocumentGetFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentGetToJson(this);
  PDocument get parent => _parent;
  @override
  void validate( List<ValidationMessage> messages, int pass) {
    if (id == null ) {
      messages.add(ValidationMessage(
          type: this.runtimeType,
          name: 'n/a',
          msg: "PDocumentGet must define an id"));
    }
  }
}

class PDocumentSelectorConverter
    implements JsonConverter<PDocumentSelector, Map<String, dynamic>> {
  const PDocumentSelectorConverter();

  @override
  PDocumentSelector fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final String typeName = json["type"];
    json.remove("type");
    switch (typeName) {
      case "PDocumentGet":
        return PDocumentGet.fromJson(json);
      default:
        throw PreceptException("Conversion required for $typeName");
    }
  }

  @override
  Map<String, dynamic> toJson(PDocumentSelector object) {
    if (object == null) {
      return null;
    }
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

  String get toKey => "$path:$itemId";
}
