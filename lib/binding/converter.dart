import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_script/schema/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

/// Function class to read dropdown selection list from a data source
abstract class SelectionReader {
  final Future<DocumentSnapshot> Function() referenceDocument;

  SelectionReader(this.referenceDocument);

  List<dynamic> call(DocumentSnapshot document);
}

class ModelConnector<MODEL, VIEW> {
  final Binding<MODEL> binding;
  final ModelViewConverter<MODEL, VIEW> converter;
  final PSchemaElement fieldSchema;

  ModelConnector(
      {@required this.binding, this.converter = const PassThroughConverter(), this.fieldSchema});

  /// It is generally better to keep the default settings of the Binding for consistency - using [readFromModel] is therefore
  /// preferred.  Use this method only if you specifically need to override the Binding settings
  VIEW readFromModelOverridingDefaults(
      {MODEL defaultValue,
      bool allowNullReturn = false,
      bool createIfAbsent = true}) {
    return converter.modelToView(binding.read(
        defaultValue: defaultValue,
        allowNullReturn: allowNullReturn,
        createIfAbsent: createIfAbsent));
  }

  String validate(VIEW inputData) {
    return converter.validate(inputData, fieldSchema);
  }

  /// See also [readFromModelOverridingDefaults]
  VIEW readFromModel() {
    return converter.modelToView(binding.read());
  }

  writeToModel(VIEW value) {
    binding.write(converter.viewToModel(value));
  }
}

abstract class ModelViewConverter<MODEL, VIEW> {
  const ModelViewConverter();

  VIEW modelToView(MODEL model, {VIEW defaultValue});

  MODEL viewToModel(VIEW view);

  /// Two stage validation.
  /// - Conversion validation from Form input data, for example, is String input a valid Integer
  /// - Model validation using [fieldSchema], for example isGreaterThan 3
  ///
  /// If conversion fails, returns the error message for that (model validation is not possible)
  /// If conversion succeeds, return result of model validation
  String validate(VIEW inputData,PField fieldSchema) {
    final conversionValidation= viewModelValidate(inputData);
    if (conversionValidation != null) return conversionValidation;
    return fieldSchema.validate(viewToModel(inputData));
  }

  /// Makes sure that the conversion can happen:
  ///
  /// Example: [IntStringConverter] will check the String only contains digits
  /// returns null if no error, otherwise contains error message
  String viewModelValidate(VIEW inputData);
}

class PassThroughConverter<T> extends ModelViewConverter<T, T> {
  const PassThroughConverter();

  @override
  T modelToView(T model, {T defaultValue}) {
    return model;
  }

  @override
  T viewToModel(T view) {
    return view;
  }

  /// No conversion, no validation needed
  @override
  String viewModelValidate(T inputData) {
    return null;
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
    throw ConfigurationException(
        'Static converter only works from model to view');
  }
}

/// Converting view back to the model rounds a double value
class IntDoubleConverter extends ModelViewConverter<int, double> {
  const IntDoubleConverter();

  @override
  double modelToView(int model, {double defaultValue}) {
    return model.toDouble();
  }

  @override
  int viewToModel(double view) {
    return view.toInt();
  }

  /// Any double can be converted back to an integer, although rounding will occur
  @override
  String viewModelValidate(double inputData) {
    return null;
  }
}

class IntStringConverter extends ModelViewConverter<int, String> {
  @override
  String modelToView(int model, {String defaultValue}) {
    return model.toString();
  }

  @override
  int viewToModel(String view) {
    assert(view != null);
    if (view.isEmpty) {
      return 0;
    } else {
      return int.parse(view);
    }
  }

  @override
  String viewModelValidate(String inputData) {
    return  validateString(Validation.isInt,inputData);
  }
}

class DoubleStringConverter extends ModelViewConverter<double, String> {
  @override
  String modelToView(double model, {String defaultValue}) {
    return model.toString();
  }

  @override
  double viewToModel(String view) {
    assert(view != null);
    if (view.isEmpty) {
      return 0;
    } else {
      return double.parse(view);
    }
  }

  @override
  String viewModelValidate(String inputData) {
    return validateString(Validation.isDouble,inputData);
  }
}


// TODO: Move timestamps to Firebase implmenetaion
class TimestampDateConverter extends ModelViewConverter<Timestamp, DateTime> {
  @override
  DateTime modelToView(Timestamp model, {DateTime defaultValue}) {
//    return  DateFormat.yMd(Locale("en","GB").toLanguageTag()).format(model.toDate());
    return model.toDate();
  }

  @override
  Timestamp viewToModel(DateTime view) {
    assert(view != null);
    return Timestamp.fromDate(view);
  }

  @override
  String viewModelValidate(DateTime inputData) {
    throw UnimplementedError();
  }
}

class TimestampStringConverter extends ModelViewConverter<Timestamp, String> {
  @override
  String modelToView(Timestamp model, {String defaultValue = "No date given"}) {
    final s = DateFormat.yMMMd().format(model.toDate());
    return (model == null) ? defaultValue : s;
  }

  @override
  Timestamp viewToModel(String view) {
    assert(view != null);
    return Timestamp.fromDate(DateFormat().parse(view));
  }

  @override
  String viewModelValidate(String inputData) {
throw UnimplementedError();
  }
}

// class BooleanStringConverter extends ModelViewConverter<bool, String> {
//   final BooleanText booleanText;
//   final bool caseSensitive;
//   final bool exceptionOnNoMatch;
//
//   const BooleanStringConverter(
//       {this.booleanText = const BooleanText(),
//       this.caseSensitive = false,
//       this.exceptionOnNoMatch = true});
//
//   @override
//   String modelToView(bool model, {String defaultValue = "No value given"}) {
//     return (model == null)
//         ? defaultValue
//         : model
//             ? booleanText.trueString
//             : booleanText.falseString;
//   }
//
//   /// If [view] does not match [booleanText.trueString] or [booleanText.falseString], by default a [ConversionException] is thrown.
//   /// If [exceptionOnNoMatch] is false, and no match occurs, then false is returned
//   @override
//   bool viewToModel(String view) {
//     if (caseSensitive) {
//       if (view == booleanText.trueString) return true;
//       if (view == booleanText.falseString) return false;
//     } else {
//       if (view.toLowerCase() == booleanText.trueString.toLowerCase())
//         return true;
//       if (view.toLowerCase() == booleanText.falseString.toLowerCase())
//         return false;
//     }
//     // If we get here then no match was found
//     if (exceptionOnNoMatch) {
//       throw ConversionException(
//           "'$view' must match either ${booleanText.trueString} or ${booleanText.falseString}");
//     } else {
//       return false;
//     }
//   }
// }

class ConversionException implements Exception {
  final String msg;

  ConversionException(this.msg);

  String errMsg() => msg;
}
