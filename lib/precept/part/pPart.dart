import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/part/part.dart';
import 'package:precept_client/precept/script/element.dart';
import 'package:precept_client/precept/script/help.dart';
import 'package:precept_client/precept/script/script.dart';

part 'pPart.g.dart';

/// Contained within a [PScript] a [PPart] describes a [Part]
/// [T] is the data type as held by the database.  Depending on how it is displayed, this may need conversion
/// [isStatic] - if true, the value is taken from [staticData], if false, the value is dynamic data loaded via [property]
/// [staticData] - the value to use if [isStatic] is true. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [caption] - the text to display as a caption.  See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [property] - the property to look up in order to get the data value.  This connects a data binding to the [SectionState] immediately above the [Part] Widget associated with this configuration.
/// [readOnly] - if true, this part is always in read only mode, regardless of any other edit state settings.  If false, the [Part] will respond to the current edit state of the [SectionState] immediately above it.
/// [help] - if non-null a small help icon button will popup when clicked. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [tooltip] - tooltip text. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
///
@JsonSerializable(nullable: true, explicitToJson: true)
class PPart<T> extends PCommon implements DisplayElement {
  final String caption;
  final bool readOnly;
  final String property;
  final String staticData;
  final PHelp help;
  final String tooltip;

  PPart(
      {this.caption,
      this.readOnly = false,
      this.property,
      bool isStatic,
      this.staticData,
      this.help,
      bool controlEdit,
      this.tooltip}): super(isStatic: isStatic, controlEdit:controlEdit);

  factory PPart.fromJson(Map<String, dynamic> json) => _$PPartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PPartToJson(this);

  Widget build() {
    final part = partLibrary.find(this.runtimeType.toString(), this);
    if (part == null) {
      String msg = "No Part is defined for $runtimeType";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return part;
  }

  @override
  bool get isStatic => super.isStatic ?? false;

  /// Overrides the [PCommon] method becuase this needs to return true if there is no other true in the chain above
  /// Walks up the tree as far as [PPage] (one below [PRoute] and returns false if any level above is true
  /// This is the 'override' mechanism, where a higher level declaring true overrides all lower levels
  bool get controlEdit {
    PCommon p=parent;
    bool setAbove=false;
    while (!(p is PRoute)){
      if (p.controlEdit != null && p.controlEdit){
        setAbove=true;
        break;
      }
      p=p.parent;
    }
    return !setAbove;
  }


}
