import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:precept/backend/firestore/binding/timestampBinding.dart';
import 'package:precept/precept/binding/converter.dart';
import 'package:precept/precept/part/part.dart';
import 'package:precept/precept/widget/caption.dart';

enum DisplayType { text, datePicker }

/// Input data type: [String]
/// Read only display: [Text] in MMDDYYYY // TODO date format
/// Edit mode display: [Cupertino Spinner]
/// See [Part]
class DatePart extends Part<Timestamp, ReadOnlyOptions, EditModeOptions> {
  const DatePart({
    Key key,
    bool readOnly,
    ReadOnlyOptions readOnlyOptions = const ReadOnlyOptions(),
    EditModeOptions editModeOptions = const EditModeOptions(),
    @required TimestampBinding binding,
    dynamic captionKey,
    IconData icon,
    EdgeInsets padding = const EdgeInsets.only(bottom: 8.0),
  }) : super(
          key: key,
          binding: binding,
          caption: captionKey,
          icon: icon,
          padding: padding,
          editModeOptions: editModeOptions,
          readOnlyOptions: readOnlyOptions,
          sourceDataType: SourceDataType.timestamp,
        );

  Widget buildReadOnlyWidget(BuildContext context) {
    final connector = ModelConnector<Timestamp, String>(
        binding: binding, converter: TimestampStringConverter());
    final text = Text(connector.readFromModel(), style: readOnlyOptions.style);
    if (readOnlyOptions.showCaption) {
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
    return DateSpinnerSelector(
      binding: binding,
    );
  }
}

// TODO incomplete
/// Use when the target data is a long way back or forward
class DateInputDistant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          child: TextFormField(
              decoration: InputDecoration(
                  labelStyle:
                      theme.textTheme.overline.apply(color: theme.primaryColor),
                  labelText: "DD",
                  border: OutlineInputBorder())),
        ),
        Container(
          width: 50,
          height: 50,
          child: TextFormField(
              decoration: InputDecoration(
                  labelStyle:
                      theme.textTheme.overline.apply(color: theme.primaryColor),
                  labelText: "MM",
                  border: OutlineInputBorder())),
        ),
        Container(
          width: 100,
          height: 50,
          child: TextFormField(
              decoration: InputDecoration(
                  labelStyle:
                      theme.textTheme.overline.apply(color: theme.primaryColor),
                  labelText: "YYYY",
                  border: OutlineInputBorder())),
        ),
      ],
    );
  }
}

class DateSpinnerSelector extends StatefulWidget {
  final TimestampBinding binding;

  const DateSpinnerSelector({Key key, @required this.binding})
      : super(key: key);

  @override
  _DateSpinnerSelectorState createState() => _DateSpinnerSelectorState();
}

class _DateSpinnerSelectorState extends State<DateSpinnerSelector> {
  @override
  Widget build(BuildContext context) {
    final textConnector = ModelConnector<Timestamp, String>(
        binding: widget.binding, converter: TimestampStringConverter());

    return Container(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // TODO make this alignment part of EditOption #223
        children: [
          Text(textConnector.readFromModelOverridingDefaults(
                  allowNullReturn: true,
                  defaultValue: null,
                  createIfAbsent: false) ??
              "Not given"),
          IconButton(
              onPressed: () => alertDialog(context, widget.binding),
              icon: Icon(
                Icons.calendar_today,
              ))
        ],
      ),
    );
  }

  alertDialog(BuildContext context, TimestampBinding binding) async {
    final valueConnector = ModelConnector<Timestamp, DateTime>(
        binding: widget.binding, converter: TimestampDateConverter());
    DateTime pickerValue = valueConnector.readFromModel();
    final picker = CupertinoDatePicker(
      initialDateTime: pickerValue,
      mode: CupertinoDatePickerMode.date,
      onDateTimeChanged: (value) {
        pickerValue = value;
      },
    );
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  valueConnector.writeToModel(pickerValue);
                  Navigator.pop(context, pickerValue);
                  setState(() {});
                },
              ),
            ],
            content: Container(
              height: 300,
              width: 400,
              child: picker,
            ),
          );
        });
  }
}
