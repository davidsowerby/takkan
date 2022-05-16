import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/script/help.dart';
import 'package:takkan_script/part/abstract_list_view.dart';

part 'query_view.g.dart';

@JsonSerializable(explicitToJson: true)
class QueryView extends AbstractListView {
  static const String defaultReadTrait = 'queryView-read-default';
  static const String defaultEditTrait = 'queryView-edit-default';
  static const String defaultItemReadTrait = 'queryView-item-read-default';
  static const String defaultItemEditTrait = 'queryView-item-edit-default';

  QueryView({
    String? queryName,
    super.titleProperty = 'title',
    super.subtitleProperty = 'subtitle',
    super.height = 100,
    super.tooltip,
    super.caption,
    super.help,
    super.id,
    super.readOnly = false,
    super.controlEdit = ControlEdit.inherited,
    super.readTraitName = 'queryView-read-default',
    super.editTraitName = 'queryView-edit-default',
  }) : super(
          property: queryName,
        );

  factory QueryView.fromJson(Map<String, dynamic> json) =>
      _$QueryViewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QueryViewToJson(this);
}
