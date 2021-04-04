import 'package:json_annotation/json_annotation.dart';

part 'layout.g.dart';




/// [padding] is added to the outside of a panel.  Bear in mind that the page containing the panel
/// may have [PPageLayout.margins] set.  Setting both has a cumulative effect.
@JsonSerializable(nullable: true, explicitToJson: true)
class PPadding {
  final double left;
  final double top;
  final double bottom;
  final double right;

  const PPadding({this.left = 0.0, this.top = 0.0, this.bottom = 0.0, this.right = 0.0});

  factory PPadding.fromJson(Map<String, dynamic> json) => _$PPaddingFromJson(json);

  Map<String, dynamic> toJson() => _$PPaddingToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PMargins {
  final double left;
  final double top;
  final double bottom;
  final double right;

  const PMargins({this.left = 0.0, this.top = 0.0, this.bottom = 0.0, this.right = 0.0});

  factory PMargins.fromJson(Map<String, dynamic> json) => _$PMarginsFromJson(json);

  Map<String, dynamic> toJson() => _$PMarginsToJson(this);
}

/// [margins] is added inside the page boundary, as opposed to [PPanelLayout.padding], which is added
/// to the outside of the panel. Setting both has a cumulative effect.
/// [preferredColumnWidth] tells the page layout algorithm what to use as as the target column width.  This
/// applies to single and multi-column layouts.  See PreceptPage.layout for more detail
@JsonSerializable(nullable: true, explicitToJson: true)
class PPageLayout  {
  final PMargins margins;
  final double preferredColumnWidth;

  const PPageLayout({this.margins = const PMargins(), this.preferredColumnWidth=360}) ;

  factory PPageLayout.fromJson(Map<String, dynamic> json) =>
      _$PPageLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$PPageLayoutToJson(this);
}