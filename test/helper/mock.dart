import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:precept_client/common/toast.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_script/app/appConfig.dart';

class MockBuildContext extends Mock implements BuildContext {
  @override
  BuildOwner get owner => MockBuildOwner();
}

class MockBuildOwner extends Mock implements BuildOwner {
  @override
  bool get debugBuilding => true;
}

class MockToast extends Mock implements Toast {}

class MockAppConfig extends Mock implements AppConfig {}

class MockDataSource extends Mock implements DataSource {}

class MockDataBinding extends Mock implements DataBinding {}

// class MockUserState extends Mock implements UserState{}
// ignore: must_be_immutable
class MockPanel extends Mock with Diagnosticable implements Widget, Panel {}


