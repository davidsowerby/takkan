import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/precept/model/model.dart';
import 'package:precept/precept/part/part.dart';

part 'pPart.g.dart';
/// Contained within a [PreceptModel] a [PPart] describes a [Part]
@JsonSerializable(nullable: true, explicitToJson: true)
class PPart {
  final String caption;
  final String property;
  final bool readOnly;

  /// [readOnly], if true, forces this part always to be in read only mode, regardless of any other settings
  const PPart({this.caption, @required this.property, this.readOnly = false});

  factory PPart.fromJson(Map<String, dynamic> json) =>
      _$PPartFromJson(json);

  Map<String, dynamic> toJson() => _$PPartToJson(this);
}
