import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/script.dart';

class FullDataBinding extends DataBinding {
  final ModelBinding binding;
  final PDocument schema;
  final DataBinding parent;

  const FullDataBinding({@required this.parent, @required this.binding, @required this.schema})
      : assert(parent != null),
        assert(binding != null),
        assert(schema != null),
        super();

  DataSource get activeDataSource => parent.activeDataSource;
}

class RootDataBinding extends FullDataBinding {
  final DataSource activeDataSource;

  const RootDataBinding(
      {@required RootBinding binding, @required PDocument schema, @required this.activeDataSource})
      : assert(binding != null),
        assert(schema != null),
        super(parent: const NoDataBinding(), schema: schema, binding: binding);
}

class NoDataBinding extends DataBinding {
  final msg = "This binding represents a 'No data' situation, making calls to it is an error";

  const NoDataBinding() : super();

  ModelBinding get binding => _throwError();

  PDocument get schema => _throwError();

  FullDataBinding get parent => _throwError();

  DataSource get activeDataSource => _throwError();

  _throwError() {
    logType(this.runtimeType).e(msg);
    throw UnsupportedError(msg);
  }
}

abstract class DataBinding {
  const DataBinding();

  ModelBinding get binding;

  PDocument get schema;

  DataBinding get parent;

  DataSource get activeDataSource;

  DataBinding childFromConfig(PContent config) {
    if (this is NoDataBinding) {
      return NoDataBinding();
    } else {
      return (config.property == '')
          ? this
          : FullDataBinding(
              parent: this,
              binding: binding.modelBinding(property: config.property),
              schema: schema.fields[config.property],
            );
    }
  }

  /// Stores a key for a Form.
  /// Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    activeDataSource.addForm(formKey);
  }

  DataBinding childFromDataSource(PDataSource dataSource, RootBinding rootBinding,
      PDocument documentSchema, DataSource activeDataSource) {
    return RootDataBinding(
        binding: rootBinding, schema: documentSchema, activeDataSource: activeDataSource);
  }

  DataBinding child(PContent config, DataBinding parentBinding, DataSource dataSource) {
    return (config.dataSourceIsDeclared)
        ? parentBinding.childFromDataSource(
            config.dataSource, dataSource.rootBinding, dataSource.documentSchema, dataSource)
        : parentBinding.childFromConfig(config);
  }
}
