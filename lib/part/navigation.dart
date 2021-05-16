
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/part/part.dart';

part 'navigation.g.dart';

@JsonSerializable( explicitToJson: true)
class PNavButton extends PPart {
  static const defaultReadTrait='PNavButton-default';
  final String route;

  PNavButton({
    bool readOnly = true,
    required this.route,
    String? caption,
    bool showCaption = false,
    IsStatic isStatic = IsStatic.yes,
    String readTraitName=defaultReadTrait,
    String? editTraitName,
    double height = 100,
    String? property,
    String staticData = '',
    final Map<String, dynamic> args = const {},
  }) : super(
          readOnly: readOnly,
          caption: caption,
          isStatic: isStatic,
          staticData: staticData,
          property: property,
          height: height,
          readTraitName: readTraitName,
          editTraitName: editTraitName,
        );

  factory PNavButton.fromJson(Map<String, dynamic> json) => _$PNavButtonFromJson(json);

  Map<String, dynamic> toJson() => _$PNavButtonToJson(this);
}

/// A simple way to specify a list of buttons which only route to another page
/// [buttons] should be specified as a map, for example {'button text':'route'}
@JsonSerializable( explicitToJson: true)
class PNavButtonSet extends PPart {
  static const defaultReadTrait='PNavButtonSet-default';
  final Map<String, String> buttons;
  final String buttonTraitName;

  PNavButtonSet({
    required this.buttons,
    double width = 150,
    double? height,
    String readTraitName=defaultReadTrait,
    this.buttonTraitName = PNavButton.defaultReadTrait,
  }) : super(
          readOnly: true,
          height: height,
          isStatic: IsStatic.yes,
          readTraitName: readTraitName,
        );

  factory PNavButtonSet.fromJson(Map<String, dynamic> json) => _$PNavButtonSetFromJson(json);

  Map<String, dynamic> toJson() => _$PNavButtonSetToJson(this);
}
