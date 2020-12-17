import 'package:flutter/material.dart';
import 'package:precept_client/precept/binding/converter.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/part/part.dart';
import 'package:precept_client/precept/widget/caption.dart';
import 'package:precept_script/script/part/pString.dart';
import 'package:precept_script/script/script.dart';


enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text]
/// Edit mode display: [TextField]
/// See [Part]
class StringPart extends Part {
  const StringPart({bool isStatic = false, @required PString config}) : super(config: config);

  Widget buildReadOnlyWidget(BuildContext context, ModelBinding baseBinding) {
    final text = Text((config.isStatic == IsStatic.yes)
        ? config.staticData
        : _textFromBinding(baseBinding: baseBinding));
    final PString cfg = config as PString;

    // TODO: styling final style =
    if (cfg.readModeOptions.showCaption) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Container(
          height: 51, // difference between read only and edit widgets
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Caption(
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

  String _textFromBinding({ModelBinding baseBinding}) {
    return _createConnector(baseBinding: baseBinding).readFromModel();
  }

  Widget buildEditModeWidget(BuildContext context, ModelBinding baseBinding) {
    final theme = Theme.of(context);
    final connector = _createConnector(baseBinding: baseBinding);
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

  ModelConnector<String, String> _createConnector({@required ModelBinding baseBinding}) {
    final binding = baseBinding.stringBinding(property: config.property);
    return ModelConnector<String, String>(
        binding: binding, converter: PassThroughConverter<String>());
  }
}


