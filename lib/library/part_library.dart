import 'package:flutter/material.dart';
import 'package:takkan_client/data/binding/connector.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/part/navigation/nav_button.dart';
import 'package:takkan_client/part/text/text_part.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/part/navigation.dart';
import 'package:takkan_script/part/part.dart';

import 'trait_library.dart';

abstract class PartLibrary {
  init(
      {Map<Type, Widget Function(Part, ModelConnector<dynamic, dynamic>)>
          entries = const {}});

  Widget constructPart({
    required ThemeData theme,
    required Part config,
    required DataContext dataContext,
    required DataBinding parentDataBinding,
    required Map<String, dynamic> pageArguments,
  });
}

class DefaultPartLibrary implements PartLibrary {
  init(
      {Map<Type, Widget Function(Part, ModelConnector<dynamic, dynamic>)>
          entries = const {}}) {}

  Widget constructPart({
    required ThemeData theme,
    required Part config,
    required DataContext dataContext,
    required DataBinding parentDataBinding,
    required Map<String, dynamic> pageArguments,
  }) {
    final trait = traitLibrary.find(
        config: config, theme: theme); // TODO: traitKey to be defined in config
    switch (trait.partName) {
      case 'TextPart':
        return TextPartBuilder().createPart(
            config: config,
            theme: theme,
            dataContext: dataContext,
            parentDataBinding: parentDataBinding);
      case 'NavButtonPart':
        return NavButtonPartBuilder().createPart(
            config: config as NavButton,
            theme: theme,
            dataContext: dataContext,
            parentDataBinding: parentDataBinding);
    }
    String msg = 'Part \'${trait.partName}\'not defined';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }
}

PartLibrary _library = DefaultPartLibrary();

PartLibrary get library => _library;



