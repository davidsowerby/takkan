import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:takkan_back4app_client/backend/back4app/authenticator/authenticator.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/base_data_provider.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/takkan_user.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/inject/inject.dart';

class Back4AppDataProvider extends BaseDataProvider<DataProvider,ParseUser> {
  Back4AppDataProvider() : super();

  DocumentId documentIdFromData(Map<String, dynamic> data) {
    return DocumentId(
        documentClass: data['__typename'], objectId: data['objectId']);
  }
}

class Back4App {
  /// Identifies the instances which will need Back4App DataProviders and creates
  /// the [getIt] bindings for them.
  ///
  /// Make sure you 'await' this call - it depends on loading the configuration
  /// file
  static register() async {

    final AppConfig appConfig=inject<AppConfig>();
    for (InstanceConfig instance in appConfig.instances) {
      if (instance.serviceType == 'back4app') {
        final provider = Back4AppDataProvider();

        getIt.registerSingleton<IDataProvider>(
          provider,
          instanceName: instance.uniqueName,
        );



        /// Although this is a factory, it is effectively a singleton, as it is
        /// held within the singleton provider
        getIt.registerFactory<Authenticator<DataProvider,ParseUser>>(
          () => Back4AppAuthenticator(provider),
          instanceName: instance.uniqueName,
        );

      }
    }
  }
}


