import 'package:flutter/material.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/converter.dart';
import 'package:precept/precept/field/radioFormField.dart';
import 'package:precept/precept/part/part.dart';

enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text]
/// Config: options to choose from [ListBinding]
/// Edit mode display: a [Column] of [RadioButtonTile]s
/// [partTheme] a map of selection value: selection label
/// See [Part]
class SingleSelectPart extends Part<String, ReadOnlyOptions, EditModeOptions> {
  final Map<String, String> choices;
  final Function(String) onSaved;
  final Function(String) onChanged;

  const SingleSelectPart({
    Key key,
    bool readOnly,
    this.onChanged,
    StringBinding binding,
    this.onSaved,
    this.choices,
    dynamic captionKey,
    IconData icon,
    EdgeInsets padding = const EdgeInsets.only(bottom: 8.0),
    ReadOnlyOptions readOnlyOptions = const ReadOnlyOptions(),
    EditModeOptions editModeOptions = const EditModeOptions(),
  }) : super(
          key: key,
          binding: binding,
          caption: captionKey,
          icon: icon,
          padding: padding,
          readOnlyOptions: readOnlyOptions,
          editModeOptions: editModeOptions,
          sourceDataType: SourceDataType.singleSelect,
        );

  Widget buildReadOnlyWidget(BuildContext context) {
    final theme = Theme.of(context);
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    final String selectedValue =
        choices[connector.readFromModel()] ?? connector.readFromModel();
    final text = Text(selectedValue, style: readOnlyOptions.style);
    if (readOnlyOptions.showCaption) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            caption,
            style: theme.textTheme.overline,
          ),
          text,
        ],
      );
    }
    return Padding(
      padding: padding,
      child: text,
    );
  }

  Widget buildEditModeWidget(BuildContext context) {
    return RadioFormField<String>(
      options: choices,
      initialValue: binding.read(),
      onSaved: _onSaved,
      onChanged: _onChanged,
    );
  }

  _onChanged(value) {
    if (onChanged != null) {
      onChanged(value);
    }
  }

  _onSaved(String value) {
    final connector = ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
    connector.writeToModel(value);
    if (onSaved != null) {
      onSaved(value);
    }
  }
}

class SingleSelectState with ChangeNotifier {
  dynamic groupValue;
}

/// [options] provides the values for selection (V) and their labels
class RadioButtonGroup<V> extends StatelessWidget {
  final Map<V, String> options;
  final V selectedOption;
  final void Function(V) onChanged;
  final bool dense;

  const RadioButtonGroup(
      {Key key,
      this.options,
      this.onChanged,
      this.selectedOption,
      this.dense = false})
      : assert(options != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = List();
    for (V option in options.keys) {
      final bool selected =
          (selectedOption != null) ? (option == selectedOption) : false;
      final title = options[option];
      final tile = RadioListTile<V>(
        value: option,
        groupValue: (selectedOption == null) ? null : selectedOption,
        onChanged: onChanged,
        selected: selected,
        title: Text(title),
      );
      tiles.add(tile);
    }
    return Column(children: tiles);
  }
}
