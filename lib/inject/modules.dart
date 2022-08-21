import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/app/app_config_loader.dart';
import 'package:takkan_backend/backend/data_provider/base_data_provider.dart';
import 'package:takkan_backend/backend/user/authenticator.dart';
import 'package:takkan_backend/backend/user/no_authenticator.dart';
import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/app/router.dart';
import 'package:takkan_client/common/locale.dart';
import 'package:takkan_client/common/toast.dart';
import 'package:takkan_client/config/asset_loader.dart';
import 'package:takkan_client/pod/page/signin_page.dart';
import 'package:takkan_client/user/signin_factory.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/server_connect.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/signin/sign_in.dart';

Future<void> takkanDefaultInjectionBindings() async{
  routerInjectionBindings();
  await persistenceInjectionBindings();
  commonInjectionBindings();
}

appConfigFromAssetBindings(){
  getIt.registerFactory<JsonFileLoader>(() => DefaultJsonAssetLoader());
  getIt.registerSingletonAsync<AppConfig>(() {
    final AppConfig appConfig=AppConfig();
    return appConfig.load();
  });
}

Future<void> persistenceInjectionBindings() async {
  getIt.registerFactory<RestServerConnect>(() => DefaultRestServerConnect());
  await getIt.isReady<AppConfig>();
  final appConfig=inject<AppConfig>();
  for (InstanceConfig instance in appConfig.instances) {
    if (instance.serviceType == 'generic') {
      final provider = BaseDataProvider();

      getIt.registerSingleton<IDataProvider>(
        provider,
        instanceName: instance.uniqueName,
      );


      /// Although this is a factory, it is effectively a singleton, as it is
      /// held within the singleton provider
      getIt.registerFactory<Authenticator>(
            () => NoAuthenticator(provider),
        instanceName: instance.uniqueName,
      );

    }
  }
}

commonInjectionBindings() {
  getIt.registerFactory<LocaleReader>(() => DefaultLocaleReader());
  getIt.registerFactory<Toast>(() => Toast());
  getIt.registerFactory<SignInFactory>(() => DefaultSignInFactory());
  getIt.registerFactory<EmailSignInFactory>(() => DefaultEmailSignInFactory());
}

routerInjectionBindings() {
  getIt.registerFactory<TakkanRouterConfig>(() => TakkanRouterConfig());
  getIt.registerFactoryParam<SignInPage, SignInOptions, int>(
      (param1, param2) => DefaultSignInPage(
            dataProvider: param1 as IDataProvider,
            pageArguments: param2 as Map<String, dynamic>,
          ));
  getIt.registerFactory<PageBuilder>(() => DefaultPageBuilder());
  // getIt.registerSingleton<TakkanRouter>(TakkanRouter());
}


