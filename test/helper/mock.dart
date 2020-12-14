import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:precept_client/common/toast.dart';

class MockBuildContext extends Mock implements BuildContext {
  @override
  BuildOwner get owner => MockBuildOwner();
}
class MockBuildOwner extends Mock implements BuildOwner {
  @override
  bool get debugBuilding => false;
}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockToast extends Mock implements Toast {}
// class MockUserState extends Mock implements UserState{}
