import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:precept_client/binding/binding.dart';

/// Function class to read dropdown selection list from a data source
abstract class SelectionReader {
  final Future<DocumentSnapshot> Function() referenceDocument;

  SelectionReader(this.referenceDocument);

  List<dynamic> call(DocumentSnapshot document);
}

class ModelConnector<MODEL, VIEW> {
  final Binding<MODEL> binding;
  final ModelViewConverter<MODEL, VIEW> converter;

  ModelConnector(
      {@required this.binding, this.converter = const PassThroughConverter()});

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
}

/// Converting back to the model rounds a double value
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
}

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
