import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/particle/pParticle.dart';
import 'package:precept_script/script/trait/textTrait.dart';

part 'pText.g.dart';

/// configures a Flutter Text widget
///
/// - [traitName] is used to lookup styles from the [TraitLibrary]
/// - [background] represents the background that this text will be written on.  It would be better if this could
/// be set automatically but at the moment has to be set manually if the background is other than standard.
/// See [open issue](https://gitlab.com/precept1/precept_client/-/issues/36)
@JsonSerializable(nullable: true, explicitToJson: true)
class PText extends PReadParticle {
  final String traitName;
  final PTextTheme background;

  const PText({this.traitName='default', this.background=PTextTheme.standard, bool showCaption = true})
      : super(showCaption: showCaption);

  factory PText.fromJson(Map<String, dynamic> json) => _$PTextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PTextToJson(this);
}
