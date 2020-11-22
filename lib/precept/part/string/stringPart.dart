import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/precept/binding/converter.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/model/element.dart';
import 'package:precept/precept/model/style.dart';
import 'package:precept/precept/part/options/options.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/widget/caption.dart';

part 'stringPart.g.dart';

enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text]
/// Edit mode display: [TextField]
/// See [Part]
class StringPart extends Part {
  final PString pPart;
  final MapBinding baseBinding;

  const StringPart({@required this.pPart, @required this.baseBinding}) : super(precept: pPart);

  Widget buildReadOnlyWidget(BuildContext context) {
    // final sectionState = Provider.of<SectionState>(context);
    final binding = baseBinding.stringBinding(property: pPart.property);
    final connector =
        ModelConnector<String, String>(binding: binding, converter: PassThroughConverter<String>());
    // TODO styling final style =
    final text = Text(connector.readFromModel());
    if (pPart.readModeOptions.showCaption) {
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

@JsonSerializable(nullable: true, explicitToJson: true)
class PString extends PPart {
  final PReadModeOptions readModeOptions;
  final PEditModeOptions editModeOptions;

  const PString({
    @required String property,
    String caption,
    this.readModeOptions = const PReadModeOptions(),
    this.editModeOptions = const PEditModeOptions(),
  }) : super(caption: caption,  property:property);

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
    this.property="not used",
  });

  factory PStaticText.fromJson(Map<String, dynamic> json) => _$PStaticTextFromJson(json);

  Map<String, dynamic> toJson() => _$PStaticTextToJson(this);
}
