import 'package:flutter/material.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/converter.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/widget/caption.dart';
import 'package:precept/precept/widget/checkbox.dart';

enum DisplayType { text, datePicker }

/// Input data type: [bool]
/// Read only display: [Text] (Various options, yes/no etc)
/// Edit mode display: [Checkbox]
/// See [Part]
class BooleanPart extends Part<bool, ReadOnlyOptions, EditModeOptions> {
  final BooleanText booleanText;
  final Function(bool) onChange;

  BooleanPart({
    Key key,
    bool readOnly,
    this.booleanText = const BooleanText(),
    BooleanBinding binding,
    @required dynamic captionKey,
    IconData icon,
    EdgeInsets padding = const EdgeInsets.only(bottom: 8.0),
    ReadOnlyOptions readOnlyOptions = const ReadOnlyOptions(),
    EditModeOptions editModeOptions = const EditModeOptions(),
    this.onChange,
  }) : super(
          key: key,
          binding: binding,
          caption: captionKey,
          icon: icon,
          padding: padding,
          editModeOptions: editModeOptions,
          readOnlyOptions: readOnlyOptions,
          sourceDataType: SourceDataType.boolean,
        );

  Widget buildReadOnlyWidget(BuildContext context) {
    final connector = ModelConnector<bool, String>(
        binding: binding,
        converter: BooleanStringConverter(booleanText: booleanText));
    final text = Text(connector.readFromModel(), style: readOnlyOptions.style);
    if (readOnlyOptions.showCaption) {
      return Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            I18NCaption(
              text: caption,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: text,
            ),
            Spacer(),
          ],
        ),
      );
    }
    return Padding(
      padding: padding,
      child: text,
    );
  }

  Widget buildEditModeWidget(BuildContext context) {
    final connector = ModelConnector<bool, bool>(
      binding: binding,
      converter: PassThroughConverter<bool>(),
    );

    List<Widget> children = List();
    if (editModeOptions.showCaption) {
      children.add(
        Flexible(
          child: I18NCaption(
            text: caption,
          ),
        ),
      );
      children.add(CheckboxStateful(
        connector: connector,
        onChange: onChange,
      ));
    }
    children.add(Spacer(
      flex: 1,
    ));
    return Row(
      children: children,
    );
  }
}

class BooleanText {
  final String trueString;
  final String falseString;

  const BooleanText({this.trueString = "Yes", this.falseString = "No"});
}
