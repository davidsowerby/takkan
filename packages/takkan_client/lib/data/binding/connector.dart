import 'package:takkan_client/app/takkan.dart';
import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/binding/list_binding.dart';
import 'package:takkan_client/data/binding/string_binding.dart';
import 'package:takkan_client/common/exceptions.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/field/string.dart';
import 'package:takkan_script/data/converter/converter.dart';

/// Connects a Field Widget to its data source, using a [ModelViewConverter] to provide conversion where needed.
/// For structural simplicity, if the data type of the Field is the same as the data type in the data source,
/// a [PassThroughConnector] is used.  It does nothing.
/// [fieldSchema] provides validation rules, used in the [validate] call.
class ModelConnector<MODEL, VIEW> {
  final Binding<MODEL> binding;
  final ModelViewConverter<MODEL, VIEW> converter;
  final Field fieldSchema;

  ModelConnector(
      {required this.binding,
      this.converter = const PassThroughConverter(),
      required this.fieldSchema});

  /// It is generally better to keep the default settings of the Binding for consistency - using [readFromModel] is therefore
  /// preferred.  Use this method only if you specifically need to override the Binding settings
  VIEW readFromModelOverridingDefaults(
      {MODEL? defaultValue,
      bool allowNullReturn = false,
      bool createIfAbsent = true}) {
    final model = binding.read(
        defaultValue: defaultValue,
        allowNullReturn: allowNullReturn,
        createIfAbsent: createIfAbsent);
    if (model != null) return converter.modelToView(model);
    String msg = 'Model cannot be null';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  /// Flutter validation requires that a null is returned if there are no validation errors.
  /// If there are multiple errors, a concatenated String is returned.
  String? validate(VIEW inputData) {
    final validationMessages =
        converter.validate(inputData, fieldSchema, script);
    return (validationMessages.isEmpty) ? null : validationMessages.join(', ');
  }

  /// See also [readFromModelOverridingDefaults]
  VIEW readFromModel() {
    final model = binding.read();
    if (model != null) return converter.modelToView(model);
    String msg='Model cannot be null';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  writeToModel(VIEW value) {
    binding.write(converter.viewToModel(value));
  }
}

/// This is a bit convoluted to get around null safety, but presents static data in place of
/// dynamic data from a database, while keeping the same code structure
class StaticConnector extends ModelConnector<String, String> {
  final String staticData;

  StaticConnector(this.staticData)
      : super(
            binding: StringBinding.private(
              property: 'not used',
              firstLevelKey: 'x',
              getEditHost: ()=>null,
              parent:
                  ListBinding.private(firstLevelKey: 'x', property: 'not used',getEditHost: ()=>null),
            ),
            fieldSchema: FString());

  @override
  String readFromModel() {
    return staticData;
  }

  writeToModel(String value) {
    throw ConfigurationException(
        'Static converter only works from model to view');
  }
}

