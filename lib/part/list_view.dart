import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/script/help.dart';
import 'package:takkan_script/part/abstract_list_view.dart';

part 'list_view.g.dart';

/// [titleProperty] and [subtitleProperty] are passed to the items in the list.  A [ListTile] for example,
/// will use these to get and display the data for an item
///
/// [isQuery] should be set to true if the data displayed is directly from a data-select
@JsonSerializable(explicitToJson: true)
class ListView extends AbstractListView {

  ListView({
    this.isQuery = false,
    this.titleProperty = 'title',
    this.subtitleProperty = 'subtitle',
    super. readOnly = false,
    super.height,
    super. caption,
    super.help,
    super. staticData,
    required super. property,
     super.traitName='ListView',
    super. tooltip,
    super. controlEdit = ControlEdit.inherited,
    super. id,
  }) ;

  factory ListView.fromJson(Map<String, dynamic> json) =>
      _$ListViewFromJson(json);

  final bool isQuery;
  @override
  final String titleProperty;
  @override
  final String subtitleProperty;

  @override
  Map<String, dynamic> toJson() => _$ListViewToJson(this);
}
