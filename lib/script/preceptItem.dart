import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/validation/message.dart';

part 'preceptItem.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PreceptItem {
  final String itemId;

  const PreceptItem({this.itemId});

  factory PreceptItem.fromJson(Map<String, dynamic> json) => _$PreceptItemFromJson(json);

  Map<String, dynamic> toJson() => _$PreceptItemToJson(this);

  String get id => itemId ?? 'missing id';

  void doValidate( List<ValidationMessage> messages, {int index=-1}){}
}