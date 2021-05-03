import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/panel/panelStyle.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/particle/list.dart';
import 'package:precept_script/trait/textTrait.dart';

part 'list.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PList extends PPart {
  PList({
    PListRead read,
    PListEdit edit,
    bool readOnly=false,
    IsStatic isStatic = IsStatic.inherited,
    double particleHeight,
    String caption,
    PHelp help,
    String staticData,
    @required String property,
    @required String readTraitName,
    String editTraitName,
    String tooltip,
    PPanelStyle panelStyle=const PPanelStyle(),
    PTextTrait textTrait=const PTextTrait(),
    ControlEdit controlEdit = ControlEdit.inherited,
  }) : super(
          caption: caption,
          controlEdit: controlEdit,
          staticData: staticData,
          property: property,
          tooltip: tooltip,
          help: help,
          height: particleHeight,
          readOnly: readOnly,
          isStatic: isStatic,
          readTraitName: readTraitName,
          editTraitName: editTraitName,
        );

  factory PList.fromJson(Map<String, dynamic> json) => _$PListFromJson(json);

  Map<String, dynamic> toJson() => _$PListToJson(this);
}

