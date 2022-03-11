import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';

part 'layout.g.dart';

/// Reduces the area available to the parent compoent effectively creating whitespace
/// around it.  Used by layouts [PLayout.padding] and individual parts.
@JsonSerializable(explicitToJson: true)
class PPadding {
  final double left;
  final double top;
  final double bottom;
  final double right;

  const PPadding(
      {this.left = 8.0, this.top = 8.0, this.bottom = 8.0, this.right = 8.0});

  factory PPadding.fromJson(Map<String, dynamic> json) =>
      _$PPaddingFromJson(json);

  Map<String, dynamic> toJson() => _$PPaddingToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PMargins {
  final double left;
  final double top;
  final double bottom;
  final double right;

  const PMargins(
      {this.left = 8.0, this.top = 8.0, this.bottom = 8.0, this.right = 8.0});

  factory PMargins.fromJson(Map<String, dynamic> json) =>
      _$PMarginsFromJson(json);

  Map<String, dynamic> toJson() => _$PMarginsToJson(this);
}

/// Common interface for type safety
abstract class PLayout {
  PPadding get padding;

  double get preferredColumnWidth;
}

/// [padding] is added inside the page boundary, as opposed to [PPanelLayout.padding], which is added
/// to the outside of the panel. Setting both has a cumulative effect.
/// [preferredColumnWidth] tells the page layout algorithm what to use as as the target column width.  This
/// applies to single and multi-column layouts.
@JsonSerializable(explicitToJson: true)
class PLayoutDistributedColumn implements PLayout {
  final PPadding padding;
  final double preferredColumnWidth;

  const PLayoutDistributedColumn(
      {this.padding = const PPadding(), this.preferredColumnWidth = 360});

  factory PLayoutDistributedColumn.fromJson(Map<String, dynamic> json) =>
      _$PLayoutDistributedColumnFromJson(json);

  Map<String, dynamic> toJson() => _$PLayoutDistributedColumnToJson(this);
}

class PLayoutJsonConverter {
  static PLayout fromJson(Map<String, dynamic> json) {
    final dataType = json['-data-'];
    switch (dataType) {
      case null:
      case 'PLayoutByColumn':
      return PLayoutDistributedColumn.fromJson(json);
      default:
        final msg = 'PLayout type $dataType not recognised';
        logName('PLayoutJsonConverter').e(msg);
        throw PreceptException(msg);
    }
  }

  static Map<String, dynamic> toJson(PLayout object) {
    final type = object.runtimeType;
    Map<String, dynamic> jsonMap = {};
    switch (type) {
      case PLayoutDistributedColumn:
        jsonMap = (object as PLayoutDistributedColumn).toJson();
        return jsonMap;
      default:
        String msg = 'PLayout type ${type.toString()} not recognised';
        logName('PLayoutJsonConverter').e(msg);
        throw PreceptException(msg);
    }
  }
}
