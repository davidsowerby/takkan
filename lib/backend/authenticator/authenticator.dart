import 'package:precept_backend/backend/authenticator/preceptUser.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/authenticator.dart';
import 'package:precept_script/script/script.dart';

abstract class AuthenticatorDelegate {
  Future<bool> registerWithEmail(PreceptUser user);

  Future<bool> signInByEmail(PreceptUser user);

  Future<bool> requestPasswordReset(PreceptUser user);

  Future<bool> updateUser(PreceptUser user);

  Future<bool> deRegister(PreceptUser user);

  init();
}

class Authenticator {
  PAuthenticator config;
  AuthenticatorDelegate _delegate;

  Authenticator.private() : _delegate = inject<AuthenticatorDelegate>();

  /// This may call [config.loadConfig] unnessarily, but it will return wihtout doing anything if it has
  /// already been called
  ///
  /// Does allow for a null [config], as it is possible that an app could be completely open
  init(PScript script) async {
    config = script.authenticator;
    if (config != null) {
      config.loadConfig();
    }
  }

  Future<bool> registerWithEmail(PreceptUser user) {
    return _delegate.registerWithEmail(user);
  }

  Future<bool> signInByEmail(PreceptUser user) {
    return _delegate.signInByEmail(user);
  }

  Future<bool> requestPasswordReset(PreceptUser user) {
    return _delegate.requestPasswordReset(user);
  }

  Future<bool> updateUser(PreceptUser user) {
    return _delegate.updateUser(user);
  }

  Future<bool> deRegister(PreceptUser user) {
    return _delegate.deRegister(user);
  }

  AuthenticatorDelegate get delegate => _delegate;
}

Authenticator _authenticator = Authenticator.private();

Authenticator get authenticator => _authenticator;

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
