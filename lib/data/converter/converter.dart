import 'package:validators/validators.dart';

import '../../schema/field/field.dart';
import '../../schema/schema.dart';
import '../../script/script.dart';

/// Function class to read dropdown selection list from a data source
// abstract class SelectionReader {
//   final Future<DocumentSnapshot> Function() referenceDocument;
//
//   SelectionReader(this.referenceDocument);
//
//   List<dynamic> call(DocumentSnapshot document);
// }


/// Converts data from the model to the view and back again.  If the model and the view use the same data type,
/// a [PassThroughConverter] is used
abstract class ModelViewConverter<MODEL, VIEW> {
  const ModelViewConverter();

  VIEW modelToView(MODEL model, {VIEW defaultValue});

  MODEL viewToModel(VIEW view);

  /// Two stage validation.
  /// - Conversion validation from Form input data, for example, is String input a valid Integer.  The check
  /// carried out is defined by the [ModelViewConverter] itself, as it knows both the View and Model types
  /// - Model, or value, validation - for example value is greater than 3.  This defined within a [Field] (part of [Schema])
  ///
  /// If conversion validation fails, returns the error message for that (model validation is not possible)
  /// If conversion validation succeeds, return result of model validation (which is an empty list
  /// if there are no validation errors)
  List<String> validate(VIEW inputData, Field<dynamic,dynamic> field, Script pScript) {
    final conversionValidation = viewModelValidate(inputData);
    if (conversionValidation) {
      return field.doValidation(viewToModel(inputData), pScript);
    } else {
      final String key = runtimeType.toString();
      return [pScript.conversionErrorMessages.patterns[key] ?? 'unknown'];
    }
  }

  /// Makes sure that the conversion can happen:
  ///
  /// Example: [IntStringConverter] will check the String only contains digits
  bool viewModelValidate(VIEW inputData);
}

class PassThroughConverter<T> extends ModelViewConverter<T, T> {
  const PassThroughConverter();

  @override
  T modelToView(T model, {T? defaultValue}) {
    return model;
  }

  @override
  T viewToModel(T view) {
    return view;
  }

  /// No conversion, no validation needed
  @override
  bool viewModelValidate(T inputData) {
    return true;
  }
}



/// Converting view back to the model rounds a double value
class IntDoubleConverter extends ModelViewConverter<int, double> {
  const IntDoubleConverter();

  @override
  double modelToView(int model, {double? defaultValue}) {
    return model.toDouble();
  }

  @override
  int viewToModel(double view) {
    return view.toInt();
  }

  /// Any double can be converted back to an integer, although rounding will occur
  @override
  bool viewModelValidate(double inputData) {
    return true;
  }
}

class IntStringConverter extends ModelViewConverter<int, String> {
  @override
  String modelToView(int model, {String? defaultValue}) {
    return model.toString();
  }

  @override
  int viewToModel(String view) {
    if (view.isEmpty) {
      return 0;
    } else {
      return int.parse(view);
    }
  }

  @override
  bool viewModelValidate(String inputData) {
    return isInt(inputData);
  }
}

class DoubleStringConverter extends ModelViewConverter<double, String> {
  @override
  String modelToView(double model, {String? defaultValue}) {
    return model.toString();
  }

  @override
  double viewToModel(String view) {
    if (view.isEmpty) {
      return 0;
    } else {
      return double.parse(view);
    }
  }

  @override
  bool viewModelValidate(String inputData) {
    return isFloat(inputData);
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

  ConversionException(this.msg);
  final String msg;

  String errMsg() => msg;
}
