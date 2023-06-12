import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';

import 'app_config.dart';

class TakkanStoreConfig extends GroupConfig {
  TakkanStoreConfig({required super.data, required super.parent})
      : super(name: AppConfig.keyTakkanStore){validate();}

  bool get isEmpty => data.isEmpty;

  bool get isNotEmpty => data.isNotEmpty;

  InstanceConfig get scriptStoreConfig => _instanceConfig('script');

  InstanceConfig get schemaStoreConfig =>  _instanceConfig('schema');

  String get type => data['type'] as String? ?? 'back4app';

  InstanceConfig _instanceConfig(String segment){
    final segmentInstanceData = data['all'] ?? data[segment];
    if (segmentInstanceData == null) {
      final String msg="a '$segment' or 'all' element must be defined in ${AppConfig.keyTakkanStore}";
      logType(runtimeType).e(msg);
      throw TakkanException(msg);
    }
    return InstanceConfig(
        name: segment,
        parent: this,
        data: segmentInstanceData as Map<String, dynamic>);

  }

  void validate() {
    if(data.containsKey('all')){
      const String msg="${AppConfig.keyTakkanStore} should contain either 'script' and 'schema' elements or an 'all' element, but not both  This data contains both." ;
      if(data.containsKey('script')){
        logType(runtimeType).e(msg);
        throw const TakkanException(msg);
      }
      if(data.containsKey('schema')){
        logType(runtimeType).e(msg);
        throw const TakkanException(msg);
      }
    }
  }
}
