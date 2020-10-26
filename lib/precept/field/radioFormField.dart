// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/precept/part/singleSelectPart.dart';

/// Creates a [FormField] that contains a [RadioButtonGroup].
///
/// [initialValue] the start up value
/// [configuration] is a <value,label> map
///
/// For documentation about the various parameters, see the [RadioButtonGroup] class
///
///
class RadioFormField<V> extends FormField<V> {
  RadioFormField({
    Key key,
    V initialValue,
    Function(V) onSaved,
    String Function(V) validator,
    bool enabled = true,
    Function(V) onChanged,
    @required Map<V, String> options,
  })  : assert(initialValue != null),
        super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidate: false,
          enabled: enabled,
          builder: (FormFieldState<V> field) {
            final _RadioFormFieldState state = field as _RadioFormFieldState;
            void onChangedHandler(V value) {
              state.onChange(value);
              if (onChanged != null) {
                onChanged(value);
              }

              field.didChange(value);
            }

            return RadioButtonGroup<V>(
              onChanged: onChangedHandler,
              options: options,
              selectedOption: state.selectedValue,
            );
          },
        );

  @override
  _RadioFormFieldState<V> createState() => _RadioFormFieldState<V>();
}

class _RadioFormFieldState<V> extends FormFieldState<V> {
  V selectedValue;

  @override
  RadioFormField<V> get widget => super.widget as RadioFormField<V>;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(RadioFormField<V> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      selectedValue = widget.initialValue;
    });
  }

  void onChange(V value) {
    setState(() {
      selectedValue = value;
    });
  }
}
