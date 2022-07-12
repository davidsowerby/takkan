// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../script/help.dart';
import '../script/script_element.dart';
import '../script/takkan_element.dart';
import 'part.dart';

part 'text.g.dart';

@JsonSerializable(explicitToJson: true)
class BodyText1 extends Part {
  BodyText1({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'BodyText1');

  factory BodyText1.fromJson(Map<String, dynamic> json) =>
      _$BodyText1FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BodyText1ToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BodyText2 extends Part {
  BodyText2({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'BodyText2');

  factory BodyText2.fromJson(Map<String, dynamic> json) =>
      _$BodyText2FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BodyText2ToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Text extends Part {
  Text(
      {super.caption,
      super.readOnly = false,
      super.height = 60,
      super.property,
      required super.traitName,
      super.staticData,
      super.help,
      super.controlEdit = ControlEdit.inherited,
      super.id,
      super.tooltip});

  factory Text.fromJson(Map<String, dynamic> json) => _$TextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TextToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Heading1 extends Part {
  Heading1({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'Heading1');

  factory Heading1.fromJson(Map<String, dynamic> json) =>
      _$Heading1FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Heading1ToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Heading2 extends Part {
  Heading2({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'Heading2');

  factory Heading2.fromJson(Map<String, dynamic> json) =>
      _$Heading2FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Heading2ToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Heading3 extends Part {
  Heading3({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'Heading3');

  factory Heading3.fromJson(Map<String, dynamic> json) =>
      _$Heading3FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Heading3ToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Heading4 extends Part {
  Heading4({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'Heading4');

  factory Heading4.fromJson(Map<String, dynamic> json) =>
      _$Heading4FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Heading4ToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Heading5 extends Part {
  Heading5({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'Heading5');

  factory Heading5.fromJson(Map<String, dynamic> json) =>
      _$Heading5FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Heading5ToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Title extends Part {
  Title({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'Title');

  factory Title.fromJson(Map<String, dynamic> json) => _$TitleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TitleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Subtitle extends Part {
  Subtitle({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'Subtitle');

  factory Subtitle.fromJson(Map<String, dynamic> json) =>
      _$SubtitleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SubtitleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Subtitle2 extends Part {
  Subtitle2({
    super.caption,
    super.readOnly = false,
    super.height = 60,
    super.property,
    super.staticData,
    super.help,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.tooltip,
  }) : super(traitName: 'Subtitle2');

  factory Subtitle2.fromJson(Map<String, dynamic> json) =>
      _$Subtitle2FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Subtitle2ToJson(this);
}
