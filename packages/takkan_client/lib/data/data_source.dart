import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_client/pod/panel/panel.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_script/script/script.dart';

/// Provides the context of a connection from data in the [DocumentCache] to a [TakkanPage] or
/// [PanelWidget].
///
/// The data itself is provided via a [CacheEntry]
///
/// A static page or panel does not use dynamic data, but may still contain an
/// implementation of [DataContext] to pass data through to lower
/// levels.
///

abstract class DataContext {
  IDataProvider get dataProvider;

  DocumentClassCache get classCache;

  Document get documentSchema;

  String get documentIdKey;
}

/// A standard [DataContext] pointing back to the relevant [DocumentClassCache]
class DefaultDataContext implements DataContext {
  final DocumentClassCache classCache;

  const DefaultDataContext({
    required this.classCache,
  });

  IDataProvider get dataProvider => classCache.dataProvider;

  Document get documentSchema => classCache.documentSchema;

  @override
  String get documentIdKey => dataProvider.objectIdKey;
}

/// An implementation to enable the use of a non-null [DataContext] property
/// in [TakkanPage] and [PanelWidget].
class NullDataContext implements DataContext {
  const NullDataContext();

  throwException() {
    String msg =
        'This is a NullDataContext and does not provide access to data ';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  @override
  IDataProvider<DataProvider> get dataProvider => throwException();

  @override
  Document get documentSchema => throwException();

  @override
  DocumentClassCache get classCache => throwException();

  @override
  String get documentIdKey => throwException();
}

/// A [TakkanPage] or [PanelWidget] which uses only static data is allocated
/// a [StaticDataContext].  This could be part way through a chain of connectors,
/// in which case the [StaticDataContext] becomes transparent, and access to dynamic data
/// is via [parent].
///
/// If, however, there is no root above this, any attempt to access a root will
/// throw an exception.  This should not happen if the [Script] has been successfully
/// validated
class StaticDataContext implements DataContext {
  final DataContext parentDataContext;

  const StaticDataContext({required this.parentDataContext});

  throwException() {
    String msg =
        'This is a StaticDataContext, and if its parent is a NullDataContext will throw an exception if you attempt to access dynamic data.  Check that your Script validates successfully.  If it does, please raise an issue';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  @override
  IDataProvider<DataProvider> get dataProvider =>
      parentDataContext.dataProvider;

  @override
  Document get documentSchema => parentDataContext.documentSchema;

  @override
  DocumentClassCache get classCache => parentDataContext.classCache;

  @override
  String get documentIdKey => parentDataContext.documentIdKey;
}
