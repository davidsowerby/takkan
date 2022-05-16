import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/part/part.dart';

part 'navigation.g.dart';

@JsonSerializable(explicitToJson: true)
class NavButton extends Part {
  static const defaultReadTrait = 'PNavButton-default';
  final String route;

  NavButton({
    super. readOnly = true,
    required this.route,
    super. caption,
    super. readTraitName = 'PNavButton-default',
    super. editTraitName = 'PNavButton-default',
    super. height = 100,
    super. property,
    super. staticData = '',
    final Map<String, dynamic> args = const {},
    super. id,
  }) ;

  factory NavButton.fromJson(Map<String, dynamic> json) =>
      _$NavButtonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NavButtonToJson(this);
}

/// A simple way to specify a list of buttons which only route to another page
/// [buttons] should be specified as a map, for example {'button text':'route'}
@JsonSerializable(explicitToJson: true)
class NavButtonSet extends Part {
  static const defaultReadTrait = 'PNavButtonSet-default';
  final Map<String, String> buttons;
  final String buttonTraitName;
  final double? width;

  NavButtonSet({
    required this.buttons,
    this.width,
    double height = 60,
    String? pid,
    String readTraitName = 'PNavButtonSet-default',
    this.buttonTraitName = 'PNavButton-default',
  }) : super(
          readOnly: true,
          height: height,
          readTraitName: readTraitName,
          id: pid,
        );

  factory NavButtonSet.fromJson(Map<String, dynamic> json) =>
      _$NavButtonSetFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NavButtonSetToJson(this);
}
