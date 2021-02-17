import 'package:flutter/foundation.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_script/data/converter/converter.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';

/// Connects a Field Widget to its data source, using a [ModelViewConverter] to provide conversion where needed.
/// For structural simplicity, if the data type of the Field is the same as the data type in the data source,
/// a [PassThroughConnector] is used.  It does nothing.
/// [fieldSchema] provides validation rules, used in the [validate] call.
class ModelConnector<MODEL, VIEW> {
  final Binding<MODEL> binding;
  final ModelViewConverter<MODEL, VIEW> converter;
  final PSchemaElement fieldSchema;

  ModelConnector(
      {@required this.binding, this.converter = const PassThroughConverter(), this.fieldSchema});

  /// It is generally better to keep the default settings of the Binding for consistency - using [readFromModel] is therefore
  /// preferred.  Use this method only if you specifically need to override the Binding settings
  VIEW readFromModelOverridingDefaults(
      {MODEL defaultValue, bool allowNullReturn = false, bool createIfAbsent = true}) {
    return converter.modelToView(binding.read(
        defaultValue: defaultValue,
        allowNullReturn: allowNullReturn,
        createIfAbsent: createIfAbsent));
  }

  /// Flutter validation requires that a null is returned if there are no validation errors.
  /// If there are multiple errors, a concatenated String is returned.
  String validate(VIEW inputData, PScript pScript) {
    final validationMessages= converter.validate(inputData, fieldSchema, pScript);
    return (validationMessages.isEmpty) ? null : validationMessages.join(', ');
  }

  /// See also [readFromModelOverridingDefaults]
  VIEW readFromModel() {
    return converter.modelToView(binding.read());
  }

  writeToModel(VIEW value) {
    binding.write(converter.viewToModel(value));
  }
}

class StaticConnector extends ModelConnector<String, String> {
  final String staticData;

  StaticConnector(this.staticData);

  @override
  String readFromModel() {
    return staticData;
  }

  writeToModel(String value) {
    throw ConfigurationException('Static converter only works from model to view');
  }
}