import 'package:flutter/material.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/part/part.dart';

import '../part/trait.dart';
import 'default_traits.dart';

abstract class TraitLibrary {
  Trait find({required Part config, required ThemeData theme});
}

class DefaultTraitLibrary implements TraitLibrary {
  final List<TraitSpec> specs = List.empty(growable: true);

  DefaultTraitLibrary() {
    specs.add(
        DefaultTraitSpec()); // TODO: this may need to be combined with user supplied specs
  }

  Trait find({required Part config, required ThemeData theme}) {
    for (TraitSpec spec in specs) {
      final result = spec.find(config: config.traitName, theme: theme);
      if (result != null) return result;
    }
    String msg = 'Trait key \'${config.traitName}\' has not be defined';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }
}

abstract class TraitSpec {
  Trait? find({required String config, required ThemeData theme});
}



TraitLibrary _traitLibrary = DefaultTraitLibrary();

TraitLibrary get traitLibrary => _traitLibrary;