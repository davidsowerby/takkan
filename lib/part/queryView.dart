
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/constants.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/part/abstractListView.dart';

part 'queryView.g.dart';

@JsonSerializable( explicitToJson: true)
class PQueryView extends PAbstractListView {
  static const String defaultReadTrait = 'queryView-read-default';
  static const String defaultEditTrait = 'queryView-edit-default';
  static const String defaultItemReadTrait = 'queryView-item-read-default';
  static const String defaultItemEditTrait = 'queryView-item-edit-default';

  PQueryView({
    String queryName = notSet,
    String titleProperty = 'title',
    String subtitleProperty = 'subtitle',
    PListViewItemType itemType = PListViewItemType.navTile,
    double height = 100,
    String? tooltip,
    String? caption,
    PHelp? help,
    String? pid,
    bool readOnly = false,
    ControlEdit controlEdit = ControlEdit.inherited,
    String readTraitName = 'queryView-read-default',
    String editTraitName = 'queryView-edit-default',
  }) : super(
          property: queryName,
          titleProperty: titleProperty,
          subtitleProperty: subtitleProperty,
          itemType: itemType,
          particleHeight: height,
          isStatic: IsStatic.no,
          tooltip: tooltip,
          caption: caption,
          help: help,
          readOnly: readOnly,
          controlEdit: controlEdit,
          readTraitName: readTraitName,
          editTraitName: editTraitName,
          pid: pid,
        );

  factory PQueryView.fromJson(Map<String, dynamic> json) => _$PQueryViewFromJson(json);

  Map<String, dynamic> toJson() => _$PQueryViewToJson(this);
}
