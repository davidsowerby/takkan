import 'package:flutter/material.dart';
import 'package:precept/precept/binding/converter.dart';

/// If specified, [onChange] is called after the widget state has been updated to the model
class CheckboxStateful extends StatefulWidget {
  final ModelConnector connector;
  final Function(bool) onChange;

  const CheckboxStateful({Key key, this.connector, this.onChange})
      : super(key: key);

  @override
  _CheckboxStatefulState createState() => _CheckboxStatefulState();
}

class _CheckboxStatefulState extends State<CheckboxStateful> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        onChanged: _onChange, value: widget.connector.readFromModel());
  }

  _onChange(bool value) {
    setState(() {
      widget.connector.writeToModel(value);
      if (widget.onChange != null) {
        widget.onChange(value);
      }
    });
  }
}
