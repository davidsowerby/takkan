import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:precept_client/common/toast.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/schema/schema.dart';

class MockBuildContext extends Mock implements BuildContext {
  @override
  BuildOwner get owner => MockBuildOwner();
}

class MockBuildOwner extends Mock implements BuildOwner {
  @override
  bool get debugBuilding => true;
}

class MockToast extends Mock implements Toast {}

class MockDataSource extends Mock implements DataSource {}

class MockDataBinding extends Mock implements DataBinding {}

// class MockUserState extends Mock implements UserState{}
// ignore: must_be_immutable
class MockPanel extends Mock with Diagnosticable implements Widget, Panel {}

class PMockDataProvider extends Mock implements PDataProviderBase {
  final PSchema schema;
  final String instanceName;

  PMockDataProvider({required this.schema, required this.instanceName});

  static register() {}
}
