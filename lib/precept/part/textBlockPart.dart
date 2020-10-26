import 'package:flutter/material.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/converter.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/widget/caption.dart';
import 'package:precept/precept/widget/text.dart';

enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text]
/// Edit mode display: [TextField]
/// See [Part]
class TextBlockPart extends Part<String, ReadOnlyOptions, TextBlockEditMode> {
  const TextBlockPart({
    Key key,
    bool readOnly,
    @required StringBinding binding,
    dynamic captionKey,
    IconData icon,
    EdgeInsets padding = const EdgeInsets.only(bottom: 8.0),
    ReadOnlyOptions readOnlyOptions = const ReadOnlyOptions(),
    TextBlockEditMode editModeOptions = const TextBlockEditMode(),
  }) : super(
          key: key,
          binding: binding,
          caption: captionKey,
          icon: icon,
          padding: padding,
          readOnlyOptions: readOnlyOptions,
          editModeOptions: editModeOptions,
          sourceDataType: SourceDataType.textBlock,
        );

  Widget buildReadOnlyWidget(BuildContext context) {
    final readOnly = ReadOnlyOptions();
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    final text =
        TextBlock(text: connector.readFromModel(), style: readOnly.style);
    if (readOnly.showCaption) {
      return Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            I18NCaption(
              text: caption,
            ),
            text,
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
    final TextBlockEditMode editMode = TextBlockEditMode();
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: TextFormField(
        maxLines: editMode.maxLines,
        initialValue: connector.readFromModel(),
        onSaved: (value) => connector.writeToModel(value),
        decoration: InputDecoration(
            labelStyle:
                theme.textTheme.overline.apply(color: theme.primaryColor),
            labelText: caption,
            border: OutlineInputBorder()),
      ),
    );
  }
}

class TextBlockEditMode extends EditModeOptions {
  final int maxLines;

  const TextBlockEditMode(
      {this.maxLines = 8, bool showCaption, bool showColumnHeading})
      : super(showColumnHeading: showColumnHeading, showCaption: showCaption);
}
