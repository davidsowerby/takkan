import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/precept/binding/converter.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/part/options/options.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/part.dart';
import 'package:precept_client/precept/script/help.dart';
import 'package:precept_client/precept/widget/caption.dart';

part 'stringPart.g.dart';

enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text]
/// Edit mode display: [TextField]
/// See [Part]
class StringPart extends Part {
  final MapBinding baseBinding;

  const StringPart({@required this.baseBinding, bool isStatic=false, PString config}) : super(config: config);

  Widget buildReadOnlyWidget(BuildContext context) {
    final text = Text((config.isStatic) ? config.staticData : _textFromBinding());
    final PString cfg=config as PString;

    // TODO: styling final style =
// TODO: shouldn't use isStatic like this, it may want a caption still
    if (!config.isStatic && cfg.readModeOptions.showCaption) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Container(
          height: 51,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: I18NCaption(
                  text: cfg.caption,
                ),
              ),
              text,
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: text,
    );
  }

  String _textFromBinding(){
    final binding = baseBinding.stringBinding(property: config.property);
    final connector =
    ModelConnector<String, String>(binding: binding, converter: PassThroughConverter<String>());
    return connector.readFromModel();
  }

  Widget buildEditModeWidget(BuildContext context) {
    final theme = Theme.of(context);
    final binding = baseBinding.stringBinding(property: config.property);
    final connector =
        ModelConnector<String, String>(binding: binding, converter: PassThroughConverter<String>());
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        initialValue: connector.readFromModel(),
        onSaved: (value) => connector.writeToModel(value),
        decoration: InputDecoration(
          isDense: true,
          labelStyle: theme.textTheme.overline.apply(color: theme.primaryColor),
          labelText: config.caption,
          border: OutlineInputBorder(gapPadding: 0),
        ),
      ),
    );
  }
}

///
/// - [property],[isStatic],[staticData], [caption],[tooltip],[help] - see [PPart]
@JsonSerializable(nullable: true, explicitToJson: true)
class PString extends PPart {
  final PReadModeOptions readModeOptions;
  final PEditModeOptions editModeOptions;

   PString({
    String property,
    String caption,
    bool isStatic,
    String static,
    String tooltip,
    PHelp help,
    this.readModeOptions = const PReadModeOptions(),
    this.editModeOptions = const PEditModeOptions(),
  }) : super(
            caption: caption,
            property: property,
            isStatic: isStatic,
            staticData: static,
            help: help,
            tooltip: tooltip);

  factory PString.fromJson(Map<String, dynamic> json) => _$PStringFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PStringToJson(this);
}


