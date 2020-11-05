
import 'package:flutter/material.dart';
import 'package:precept/common/logger.dart';
import 'package:precept/precept/document/documentState.dart';

/// Precept potentially creates a number of [Form] instances on one page, as each [Section]
/// may have its own.  This class just holds the [GlobalKey] for each, so that all can be saved
/// when a document save is executed.
class FormLog with ChangeNotifier{
  final List<GlobalKey<FormState>> formKeys = List();
  /// Called by a [Section] creating a Form.  Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    getLogger(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  /// Iterates though form keys registered by [Section] instances through [addForm], 'saves' the [Form] - that is, transfers data from
  /// the [Form] back to the [DocumentState] via [Binding]s - the bindings are provided by [Part] components
  /// within the [Section] (and therefore within the [Form] if the [Section] is in edit mode.)
  flushFormsToModel() {
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState.save();
        getLogger(this.runtimeType).d("Form saved for $key");
      }
    }
    // TODO: purge those with null current state
  }
}