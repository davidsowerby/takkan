import 'package:takkan_client/app/page_builder.dart';
import 'package:takkan_client/app/router.dart';
import 'package:takkan_client/common/locale.dart';
import 'package:takkan_client/common/toast.dart';
import 'package:takkan_client/config/asset_loader.dart';
import 'package:takkan_client/pod/page/signin_page.dart';
import 'package:takkan_client/user/signin_factory.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/data_provider_library.dart';
import 'package:takkan_backend/backend/data_provider/server_connect.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/signin/sign_in.dart';

void takkanDefaultInjectionBindings() {
  commonInjectionBindings();
  libraryInjectionBindings();
  routerInjectionBindings();
  persistenceInjectionBindings();
}

void persistenceInjectionBindings() {
  getIt.registerFactory<RestServerConnect>(() => DefaultRestServerConnect());
}

commonInjectionBindings() {
  getIt.registerFactory<LocaleReader>(() => DefaultLocaleReader());
  getIt.registerFactory<Toast>(() => Toast());
  getIt.registerFactory<JsonAssetLoader>(() => DefaultJsonAssetLoader());
  getIt.registerFactory<SignInFactory>(() => DefaultSignInFactory());
  getIt.registerFactory<EmailSignInFactory>(() => DefaultEmailSignInFactory());
}

libraryInjectionBindings() {

  getIt.registerSingleton<DataProviderLibrary>(DefaultDataProviderLibrary());
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


