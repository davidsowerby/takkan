import 'package:precept_backend/backend/authenticator.dart';
import 'package:precept_backend/backend/preceptUser.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataProvider.dart';
import 'package:precept_script/script/script.dart';

class Backend {
  PDataProvider dataProvider;
  Authenticator _authenticator;
  PBackend _config;

  Backend.private() {
    _authenticator = inject<Authenticator>();
  }

  Future<bool> registerWithEmail(PreceptUser user) {
    return _authenticator.registerWithEmail(user);
  }

  Future<bool> signInByEmail(PreceptUser user) {
    return _authenticator.signInByEmail(user);
  }

  Future<bool> requestPasswordReset(PreceptUser user) {
    return _authenticator.requestPasswordReset(user);
  }

  Future<bool> updateUser(PreceptUser user) {
    return _authenticator.updateUser(user);
  }

  Future<bool> deRegister(PreceptUser user) {
    return _authenticator.deRegister(user);
  }

  Authenticator get authenticator => _authenticator;
  
  init(PScript script, Map<String,dynamic> jsonConfig){
    _config=script.backend;
    assert(_config!=null);
    final configBlock=jsonConfig[authenticator.configKey];
    final instanceConfig=configBlock[_config.instanceName];
    if (instanceConfig==null){
      final String msg='Configuration for instance ${_config.instanceName} not found in precept.json';
      logType(this.runtimeType).e(msg);
      throw ConfigurationException(msg);
    }
    dataProvider=_authenticator.dataProvider(schema: _config.schema,jsonConfig: instanceConfig);
  }
}

Backend _backend = Backend.private();

Backend get backend => _backend;
