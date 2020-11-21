import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/precept/model/element.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/schema/schema.dart';

part 'pPart.g.dart';
/// Contained within a [PModel] a [PPart] describes a [Part]
/// [T] is the data type as held by the database.  Depending on how it is displayed, this may need conversion
@JsonSerializable(nullable: true, explicitToJson: true)
class PPart<T> implements DisplayElement {
  final String caption;
  final bool readOnly;
  @JsonKey(ignore:true)
  final SchemaField<T> schema;

  /// [readOnly], if true, forces this part always to be in read only mode, regardless of any other settings
  const PPart({this.caption,  this.readOnly = false,@required this.schema});

  factory PPart.fromJson(Map<String, dynamic> json) =>
      _$PPartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PPartToJson(this);
}
