// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../script/help.dart';
import '../script/script_element.dart';
import 'abstract_list_view.dart';

part 'query_view.g.dart';

@JsonSerializable(explicitToJson: true)
class QueryView extends AbstractListView {
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
    required super.traitName,
  }) : super(
          property: queryName,
        );

  factory QueryView.fromJson(Map<String, dynamic> json) =>
      _$QueryViewFromJson(json);
  static const String defaultReadTrait = 'queryView-read-default';
  static const String defaultEditTrait = 'queryView-edit-default';
  static const String defaultItemReadTrait = 'queryView-item-read-default';
  static const String defaultItemEditTrait = 'queryView-item-edit-default';

  @override
  Map<String, dynamic> toJson() => _$QueryViewToJson(this);
}
