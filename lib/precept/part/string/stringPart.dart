import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept/precept/binding/converter.dart';
import 'package:precept/precept/part/options/options.dart';
import 'package:precept/precept/part/pPart.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/style/library/styleLibrary.dart';
import 'package:precept/precept/widget/caption.dart';
import 'package:precept/section/base/sectionState.dart';
import 'package:provider/provider.dart';

part 'stringPart.g.dart';

enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text]
/// Edit mode display: [TextField]
/// See [Part]
class StringPart extends Part {
  final PStringPart pPart;

  const StringPart({@required this.pPart}) : super(precept: pPart);

  Widget buildReadOnlyWidget(BuildContext context) {
    final sectionBinding = Provider.of<SectionState>(context, listen: false);
    final binding =
        sectionBinding.dataBinding.stringBinding(property: precept.property);
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    final style =
        styleLibrary.findStyle(pPart.readModeOptions.styleName); // TODO styling
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
    final sectionBinding = Provider.of<SectionState>(context, listen: false);
    final binding =
        sectionBinding.dataBinding.stringBinding(property: precept.property);
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
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
class PStringPart extends PPart {
  final PReadModeOptions readModeOptions;
  final PEditModeOptions editModeOptions;

  PStringPart({
    String caption,
    @required String property,
    this.readModeOptions = const PReadModeOptions(),
    this.editModeOptions = const PEditModeOptions(),
  }) : super(caption: caption, property: property);

  factory PStringPart.fromJson(Map<String, dynamic> json) =>
      _$PStringPartFromJson(json);

  Map<String, dynamic> toJson() => _$PStringPartToJson(this);
}
