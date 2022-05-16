import 'package:flutter/material.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/trait/style.dart' as ConfigStyle;

// TODO: think about iteration order, it could be used to 'overwrite' previous declarations
class BorderLibrary {
  final List<BorderLibraryModule> modules;

  const BorderLibrary({required this.modules});

  /// Iterates through [modules] to find the [border], throws exception if none found
  ShapeBorder find(
      {required ThemeData theme, required ConfigStyle.Border border}) {
    for (var module in modules) {
      final result = module.find(theme: theme, border: border);
      if (result != null) {
        return result;
      }
    }
    throw TakkanException(
        "Border ${border.borderName} not found in the BorderLibrary");
  }
}

abstract class BorderLibraryModule {
  const BorderLibraryModule();

  /// Returns the border for [borderName] or null if not found
  ShapeBorder? find(
      {required ThemeData theme, required ConfigStyle.Border border});
}

class TakkanBorderLibraryModule extends BorderLibraryModule {
  TakkanBorderLibraryModule() : super();

  @override
  ShapeBorder? find(
      {required ThemeData theme, required ConfigStyle.Border border}) {
    switch (border.borderName) {
      case ConfigStyle.Border.roundedRectangleThinPrimary:
        return _roundedRectangle(theme: theme, lineThickness: 1.0);
      case ConfigStyle.Border.roundedRectangleMediumPrimary:
        return _roundedRectangle(theme: theme, lineThickness: 3.0);
      case ConfigStyle.Border.roundedRectangleThickPrimary:
        return _roundedRectangle(theme: theme, lineThickness: 5.0);
      default:
        return null;
    }
  }

  RoundedRectangleBorder _roundedRectangle({required ThemeData theme, required double lineThickness}){
    return RoundedRectangleBorder(
        side: BorderSide(style: BorderStyle.solid, width: lineThickness, color: theme.primaryColor),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ));
  }
}


BorderLibrary get borderLibrary => inject<BorderLibrary>();
