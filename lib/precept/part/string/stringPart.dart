import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_client/precept/binding/converter.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/model/element.dart';
import 'package:precept_client/precept/model/help.dart';
import 'package:precept_client/precept/model/style.dart';
import 'package:precept_client/precept/part/options/options.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/part/part.dart';
import 'package:precept_client/precept/widget/caption.dart';

part 'stringPart.g.dart';

enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text]
/// Edit mode display: [TextField]
/// See [Part]
class StringPart extends Part {
  final PString pPart;
  final MapBinding baseBinding;

  const StringPart({@required this.pPart, @required this.baseBinding, bool isStatic=false}) : super(precept: pPart, isStatic: isStatic);

  Widget buildReadOnlyWidget(BuildContext context) {
    final text = Text((isStatic) ? pPart.static : _textFromBinding());

    // TODO: styling final style =
// TODO: shouldn't use isStatic like this, it may want a caption still
    if (!isStatic && pPart.readModeOptions.showCaption) {
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
                  text: pPart.caption,
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
    final binding = baseBinding.stringBinding(property: pPart.property);
    final connector =
    ModelConnector<String, String>(binding: binding, converter: PassThroughConverter<String>());
    return connector.readFromModel();
  }

  Widget buildEditModeWidget(BuildContext context) {
    final theme = Theme.of(context);
    final binding = baseBinding.stringBinding(property: pPart.property);
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
          labelText: pPart.caption,
          border: OutlineInputBorder(gapPadding: 0),
        ),
      ),
    );
  }
}

///
/// - [property],[isStatic],[static], [caption],[tooltip],[help] - see [PPart]
@JsonSerializable(nullable: true, explicitToJson: true)
class PString extends PPart {
  final PReadModeOptions readModeOptions;
  final PEditModeOptions editModeOptions;

  const PString({
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
            static: static,
            help: help,
            tooltip: tooltip);

  factory PString.fromJson(Map<String, dynamic> json) => _$PStringFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PStringToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PStaticText implements DisplayElement {
  final String text;
  final String caption;
  final PTextStyle style;
  final PTextTheme theme;
  final bool softWrap;
  final String property;

  const PStaticText({
    @required this.text,
    this.style = PTextStyle.bodyText1,
    this.theme = PTextTheme.standard,
    this.caption,
    this.softWrap = true,
    this.property = "not used",
  });

  factory PStaticText.fromJson(Map<String, dynamic> json) => _$PStaticTextFromJson(json);

  Map<String, dynamic> toJson() => _$PStaticTextToJson(this);
}
