import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';

part 'layout.g.dart';

/// Reduces the area available to the parent component effectively creating whitespace
/// around it.  Used by layouts [Layout.padding] and individual parts.
@JsonSerializable(explicitToJson: true)
class Padding {
  const Padding(
      {this.left = 8.0, this.top = 8.0, this.bottom = 8.0, this.right = 8.0});

  factory Padding.fromJson(Map<String, dynamic> json) =>
      _$PaddingFromJson(json);
  final double left;
  final double top;
  final double bottom;
  final double right;

  Map<String, dynamic> toJson() => _$PaddingToJson(this);
}

/// Common interface for type safety
abstract class Layout {
  Padding get padding;

  double get preferredColumnWidth;
}

/// [padding] is added inside the page boundary, as opposed to [PPanelLayout.padding], which is added
/// to the outside of the panel. Setting both has a cumulative effect.
/// [preferredColumnWidth] tells the page layout algorithm what to use as as the target column width.  This
/// applies to single and multi-column layouts.
@JsonSerializable(explicitToJson: true)
class LayoutDistributedColumn extends Equatable implements Layout {
  const LayoutDistributedColumn(
      {this.padding = const Padding(), this.preferredColumnWidth = 360});

  factory LayoutDistributedColumn.fromJson(Map<String, dynamic> json) =>
      _$LayoutDistributedColumnFromJson(json);
  @override
  final Padding padding;
  @override
  final double preferredColumnWidth;

  Map<String, dynamic> toJson() => _$LayoutDistributedColumnToJson(this);

  @override
  List<Object?> get props => [padding, preferredColumnWidth];
}

// ignore: avoid_classes_with_only_static_members
class LayoutJsonConverter {
  static Layout fromJson(Map<String, dynamic> json) {
    final dataType = json['-data-'];
    switch (dataType) {
      case null:
      case 'LayoutDistributedColumn':
        return LayoutDistributedColumn.fromJson(json);
      default:
        final msg = 'Layout type $dataType not recognised';
        logName('LayoutJsonConverter').e(msg);
        throw TakkanException(msg);
    }
  }

  static Map<String, dynamic> toJson(Layout object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = {};
    switch (type) {
      case LayoutDistributedColumn:
        jsonMap = (object as LayoutDistributedColumn).toJson();
        return jsonMap;
      default:
        final String msg = 'Layout type ${type.toString()} not recognised';
        logName('LayoutJsonConverter').e(msg);
        throw TakkanException(msg);
    }
  }
}
