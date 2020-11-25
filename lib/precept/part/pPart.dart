import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/precept/model/element.dart';
import 'package:precept_client/precept/model/help.dart';
import 'package:precept_client/precept/model/model.dart';
import 'package:precept_client/precept/part/part.dart';

part 'pPart.g.dart';
/// Contained within a [PModel] a [PPart] describes a [Part]
/// [T] is the data type as held by the database.  Depending on how it is displayed, this may need conversion
/// [isStatic] - if true, the value is taken from [static], if false, the value is dynamic data loaded via [property]
/// [static] - the value to use if [isStatic] is true. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [caption] - the text to display as a caption.  See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [property] - the property to look up in order to get the data value.  This connects a data binding to the [SectionState] immediately above the [Part] Widget associated with this configuration.
/// [readOnly] - if true, this part is always in read only mode, regardless of any other edit state settings.  If false, the [Part] will respond to the current edit state of the [SectionState] immediately above it.
/// [help] - if non-null a small help icon button will popup when clicked. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [tooltip] - tooltip text. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
///
@JsonSerializable(nullable: true, explicitToJson: true)
class PPart<T> implements DisplayElement {
  final String caption;
  final bool readOnly;
  final String property;
  final bool isStatic;
  final String static;
  final PHelp help;
  final String tooltip;

  const PPart({this.caption,  this.readOnly = false,@required this.property, this.isStatic, this.static, this.help, this.tooltip});

  factory PPart.fromJson(Map<String, dynamic> json) =>
      _$PPartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PPartToJson(this);
}
