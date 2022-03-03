import 'package:precept_script/common/script/precept_item.dart';

/// Common base class for delegates to PDataProvider
abstract class PDataProviderDelegate with WalkTarget {
  final bool checkHealthOnConnect;

  const PDataProviderDelegate({
    this.checkHealthOnConnect = false,
  });
}

/// Used primarily to select defaults.  Using an enum in case we want a third option,
/// possibly SDK
enum Delegate { graphQl, rest }
