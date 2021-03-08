import 'package:precept_backend/backend/preceptUser.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataProvider.dart';

abstract class Authenticator<T extends PDataProvider> {
  Future<bool> registerWithEmail(PreceptUser user);

  Future<bool> signInByEmail(PreceptUser user);

  Future<bool> requestPasswordReset(PreceptUser user);

  Future<bool> updateUser(PreceptUser user);

  Future<bool> deRegister(PreceptUser user);

  String get configKey;

  init();
  /// Creates and returns an instance of the relevant [PDataProvider] type, set up from [jsonConfig] rather
  /// than being explicitly declared by the developer.
  ///
  /// The relevant part of *precept.json* is extracted and passed to this method
  T dataProvider({PSchema schema, Map<String, dynamic> jsonConfig});
}



enum SignInStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Authentication_Failed,
  Registering,
  Registered,
  RegistrationFailed,
  User_Not_Known,
}
