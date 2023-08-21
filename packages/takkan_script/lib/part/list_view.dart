// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../script/help.dart';
import '../script/script_element.dart';
import 'part.dart';

part 'list_view.g.dart';

/// [titleProperty] and [subtitleProperty] are passed to the items in the list.  A [ListTile] for example,
/// will use these to get and display the data for an item
///
@JsonSerializable(explicitToJson: true)
class ListView extends Part {
  ListView({
    this.titleProperty = 'title',
    this.subtitleProperty = 'subtitle',
    super.readOnly = false,
    super.height,
    super.caption,
    super.help,
    super.staticData,
    required super.property,
    super.traitName = 'ListView',
    super.tooltip,
    super.controlEdit = ControlEdit.inherited,
    super.id,
  });

  factory ListView.fromJson(Map<String, dynamic> json) =>
      _$ListViewFromJson(json);

  final String titleProperty;
  final String subtitleProperty;

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [
        ...super.props,
        titleProperty,
        subtitleProperty,
      ];

  @override
  Map<String, dynamic> toJson() => _$ListViewToJson(this);
}
