// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../panel/panel.dart';
import '../validation/message.dart';
import 'script_element.dart';
import 'takkan_element.dart';
import 'walker.dart';

part 'content.g.dart';

/// Common sub-class for all the content, whether Page, Panel or Part
@JsonSerializable(explicitToJson: true)
class Content extends ScriptElement {
  Content({
    this.caption,
    this.property,
    this.listEntryConfig,
    super.dataProvider,
    super.controlEdit,
    super.id,
  });

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
  String? caption;
  final String? property;
  final Panel? listEntryConfig;

  @JsonKey(ignore: true)
  @override
  List<Object?> get props =>
      [...super.props, caption, property, listEntryConfig];

  bool get isStatic => property == null;

  @override
  void doInit(InitWalkerParams params) {
    super.doInit(params);
    if ((!isStatic) && caption == null) {
      caption = property;
    }
  }

  @override
  void doValidate(ValidationWalkerCollector collector) {
    super.doValidate(collector);
    if (isStatic) {
      if (property == null) {
        collector.messages.add(
          ValidationMessage(
            item: this,
            msg:
                'is not static, and must therefore declare a property (which can be an empty String)',
          ),
        );
      }
      if (!hasEditControl && !inheritedEditControl) {
        collector.messages.add(
          ValidationMessage(
            item: this,
            msg:
                'is not static, but there is no editControl set in this or its parent chain',
          ),
        );
      }
    }
  }

  @override
  String? get idAlternative => caption;

  @override
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
