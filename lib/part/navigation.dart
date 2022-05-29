import 'package:json_annotation/json_annotation.dart';
import 'part.dart';

part 'navigation.g.dart';

@JsonSerializable(explicitToJson: true)
class NavButton extends Part {
  NavButton({
    required this.route,
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
  final String route;

  @override
  Map<String, dynamic> toJson() => _$NavButtonToJson(this);
}

/// A simple way to specify a list of buttons which only route to another page
/// [buttons] should be specified as a map, for example {'button text':'route'}
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
  final Map<String, String> buttons;
  final double? width;

  @override
  Map<String, dynamic> toJson() => _$NavButtonSetToJson(this);
}
