import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:test/fake.dart';

class FakeAuthenticator extends Fake implements Authenticator<DataProvider,dynamic> {}
