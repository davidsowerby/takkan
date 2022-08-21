// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/takkan/walker.dart';

import '../page/page.dart';
import 'part.dart';

part 'navigation.g.dart';

/// Configuration for a Flutter button which causes the client Router to navigate
/// to the Page and DataSelector specified in [toPage] and [toData].
@JsonSerializable(explicitToJson: true)
class NavButton extends Part {
  NavButton({
    required this.toPage,
    required this.toData,
    super.caption,
    super.traitName = 'NavButton',
    super.height = 100,
    super.property,
    super.id,
  }) : super(
          readOnly: true,
        );

  factory NavButton.fromJson(Map<String, dynamic> json) =>
      _$NavButtonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NavButtonToJson(this);

  final String toPage;
  final String toData;

  String get route =>
      TakkanRoute(pageName: toPage, dataSelectorName: toData).toString();

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [...super.props, toPage, toData];

  @override
  void doInit(InitWalkerParams params) {
    super.doInit(params);
    script.pageFromStringRoute(route);
  }
}

/// A simple way to specify a group of buttons which only route to another page
/// [buttons] are specified as list of [NavButton]
@JsonSerializable(explicitToJson: true)
class NavButtonSet extends Part {
  NavButtonSet({
    required this.buttons,
    this.width,
    super.height = 60,
    String? pid,
    super.traitName = 'NavButtonSet',
  }) : super(
          readOnly: true,
          id: pid,
        );

  factory NavButtonSet.fromJson(Map<String, dynamic> json) =>
      _$NavButtonSetFromJson(json);
  final List<NavButton> buttons;
  final double? width;

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [...super.props, buttons, width];

  @override
  Map<String, dynamic> toJson() => _$NavButtonSetToJson(this);
}
