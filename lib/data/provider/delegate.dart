import 'package:takkan_schema/takkan/walker.dart';

/// Common base class for delegates to PDataProvider
abstract class DataProviderDelegate with WalkTarget {
  const DataProviderDelegate({
    this.checkHealthOnConnect = false,
  });

  final bool checkHealthOnConnect;
}

/// Used primarily to select defaults.  Using an enum in case we want a third option,
/// possibly SDK
enum Delegate { graphQl, rest }
