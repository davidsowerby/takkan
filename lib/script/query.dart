import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/preceptItem.dart';
import 'package:precept_script/validation/message.dart';

part 'query.g.dart';

/// Roughly equivalent to a query with an expected result of one document.
///
/// Specifies how to retrieve a single document in a backend-neutral way
/// Supports various ways of identifying the document:
/// - 'get' with a document id
/// - 'select distinct' with criteria expressed in parameters
/// - 'select first'
/// - 'select last'

/// Classes used to define selection method and criteria for a document
///
//// Should not be instantiated directly - it would be abstract if that would work with JSON serialization

@JsonSerializable(nullable: true, explicitToJson: true)
class PDataSource extends PreceptItem {

  PDataSource({this.params}) ;

  factory PDataSource.fromJson(Map<String, dynamic> json) =>
      _$PDataSourceFromJson(json);

  final Map<String, dynamic> params;


  void doValidate( List<ValidationMessage> messages, {int index=-1}){}


  Map<String, dynamic> toJson() => _$PDataSourceToJson(this);
}

/// Retrieves a single document using a [DocumentId]
@JsonSerializable(nullable: true, explicitToJson: true)
class PDataGet extends PDataSource {
  final DocumentId documentId;

   PDataGet({@required this.documentId, @required Map<String, dynamic> params})
      : super(params: params);

  factory PDataGet.fromJson(Map<String, dynamic> json) =>
      _$PDataGetFromJson(json);

  Map<String, dynamic> toJson() => _$PDataGetToJson(this);

  @override
  void doValidate( List<ValidationMessage> messages, {int index=-1}) {
    if (documentId == null ) {
      messages.add(ValidationMessage(
          item: this,
          msg: "PDataGet must define a documentId"));
    }
  }
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PDataStream  {

  PDataStream() ;

  factory PDataStream.fromJson(Map<String, dynamic> json) =>
      _$PDataStreamFromJson(json);

  Map<String, dynamic> toJson() => _$PDataStreamToJson(this);
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
