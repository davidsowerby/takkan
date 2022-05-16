import 'package:takkan_script/script/precept_item.dart';

/// Common base class for delegates to PDataProvider
abstract class DataProviderDelegate with WalkTarget {
  final bool checkHealthOnConnect;

  const DataProviderDelegate({
    this.checkHealthOnConnect = false,
  });
}

/// Used primarily to select defaults.  Using an enum in case we want a third option,
/// possibly SDK
enum Delegate { graphQl, rest }
