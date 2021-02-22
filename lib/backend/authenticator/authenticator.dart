import 'package:precept_backend/backend/authenticator/preceptUser.dart';

abstract class Authenticator{
  Future<bool> registerWithEmail(PreceptUser user);
  Future<bool> signInByEmail(PreceptUser user);
  Future<bool> requestPasswordReset(PreceptUser user);
  Future<bool> updateUser (PreceptUser user);
  Future<bool> deRegister(PreceptUser user);
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