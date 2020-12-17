import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/validation/message.dart';

part 'preceptItem.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PreceptItem {
  final String _id;

  const PreceptItem({String id}) : _id=id;

  factory PreceptItem.fromJson(Map<String, dynamic> json) => _$PreceptItemFromJson(json);

  Map<String, dynamic> toJson() => _$PreceptItemToJson(this);

  String get id => _id ?? 'missing id';

  void doValidate( List<ValidationMessage> messages, {int index=-1}){}
}