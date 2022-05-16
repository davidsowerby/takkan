import 'package:flutter/material.dart';
import 'package:takkan_client/binding/connector.dart';

/// If specified, [onChange] is called after the widget state has been updated to the model
class CheckboxStateful extends StatefulWidget {
  final ModelConnector connector;
  final Function(bool?)? onChange;

  const CheckboxStateful({super.key, required this.connector, this.onChange});

  @override
  _CheckboxStatefulState createState() => _CheckboxStatefulState();
}

class _CheckboxStatefulState extends State<CheckboxStateful> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        onChanged: _onChange, value: widget.connector.readFromModel());
  }

  _onChange(bool? value) {
    setState(() {
      widget.connector.writeToModel(value);
      if (widget.onChange != null) {
        widget.onChange!(value);
      }
    });
  }
}
