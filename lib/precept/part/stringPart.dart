import 'package:flutter/material.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/converter.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/widget/caption.dart';

enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text]
/// Edit mode display: [TextField]
/// See [Part]
/// [caption] should be an I18N key
class StringPart extends Part<String, ReadOnlyOptions, EditModeOptions> {
  const StringPart({
    Key key,
    bool readOnly,
    ReadOnlyOptions readOnlyOptions = const ReadOnlyOptions(),
    EditModeOptions editModeOptions = const EditModeOptions(),
    @required StringBinding binding,
    dynamic captionKey,
    IconData icon,
    EdgeInsets padding = const EdgeInsets.only(bottom: 8.0),
  }) : super(
          key: key,
          binding: binding,
          caption: captionKey,
          icon: icon,
          padding: padding,
          readOnlyOptions: readOnlyOptions,
          editModeOptions: editModeOptions,
          sourceDataType: SourceDataType.string,
        );

  Widget buildReadOnlyWidget(BuildContext context) {
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    final text = Text(connector.readFromModel(), style: readOnlyOptions.style);
    if (readOnlyOptions.showCaption) {
      return Padding(
        padding: padding,
        child: Container(
          height: 51,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: I18NCaption(
                  text: caption,
                ),
              ),
              text,
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: padding,
      child: text,
    );
  }

  Widget buildEditModeWidget(BuildContext context) {
    final theme = Theme.of(context);
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    return Padding(
      padding: padding,
      child: TextFormField(
        initialValue: connector.readFromModel(),
        onSaved: (value) => connector.writeToModel(value),
        decoration: InputDecoration(
          isDense: true,
          labelStyle: theme.textTheme.overline.apply(color: theme.primaryColor),
          labelText: caption,
          border: OutlineInputBorder(gapPadding: 0),
        ),
      ),
    );
  }
}
