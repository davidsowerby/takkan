import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/validation/message.dart';

part 'content.g.dart';

/// Common sub-class for all the content, whether Page, Panel or Part
@JsonSerializable(explicitToJson: true)
class Content extends Common {
  String? caption;
  final String? property;
  final Panel? listEntryConfig;

  Content({
    this.caption,
    this.property,
    this.listEntryConfig,
    DataProvider? dataProvider,
    ControlEdit controlEdit = ControlEdit.inherited,
    String? id,
  }) : super(
          dataProviderConfig: dataProvider,
          controlEdit: controlEdit,
          id: id,
        );

  bool get isStatic => property == null;

  @override
  doInit(InitWalkerParams params) {
    super.doInit(params);
    if ((!isStatic) && caption == null) {
      caption = property;
    }
  }

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
      if (!hasEditControl && !(inheritedEditControl)) {
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

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
