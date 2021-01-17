import 'package:flutter/foundation.dart';

import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:precept_backend/backend/backend.dart';
import 'package:precept_script/common/log.dart';
import 'package:sembast/sembast_memory.dart';

/// Initialises whichever backend is being used
abstract class BackendInitialiser {
  Env _env;
  CoreStore _coreStore;

  BackendInitialiser();

  /// This usually needs to be called AFTER backend specific code
  init({@required Env env}) async {
    _env = env;
    _coreStore = (env == Env.prod)
        ? await CoreStoreSembastImp.getInstance('sembast')
        : await CoreStoreSembastImp.getInstance('sembast',factory: databaseFactoryMemory);
    await connect();
    String health = await healthCheck();
    logType(this.runtimeType).i(health);
    // FeatureSwitch().init();
    return health == "OK";
  }

  CoreStore get coreStore => _coreStore;

  Env get env => _env;

  @protected
  connect();

  Future<String> healthCheck();
}
