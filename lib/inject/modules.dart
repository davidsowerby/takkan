import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_backend/backend/data_provider/server_connect.dart';
import 'package:precept_client/app/page_builder.dart';
import 'package:precept_client/app/router.dart';
import 'package:precept_client/common/locale.dart';
import 'package:precept_client/common/toast.dart';
import 'package:precept_client/config/asset_loader.dart';
import 'package:precept_client/library/border_library.dart';
import 'package:precept_client/library/theme_lookup.dart';
import 'package:precept_client/page/signin_page.dart';
import 'package:precept_client/user/signin_factory.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/signin/sign_in.dart';

void preceptDefaultInjectionBindings() {
  commonInjectionBindings();
  libraryInjectionBindings();
  routerInjectionBindings();
  themeInjectionBindings();
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
  getIt.registerSingleton<BorderLibrary>(
      BorderLibrary(modules: [PreceptBorderLibraryModule()]));
  getIt.registerSingleton<DataProviderLibrary>(DefaultDataProviderLibrary());
}

routerInjectionBindings() {
  getIt.registerFactory<PreceptRouterConfig>(() => PreceptRouterConfig());
  getIt.registerFactoryParam<SignInPage, PSignInOptions, int>(
      (param1, param2) => DefaultSignInPage(
            dataProvider: param1 as DataProvider,
            pageArguments: param2 as Map<String, dynamic>,
          ));
  getIt.registerFactory<PageBuilder>(() => DefaultPageBuilder());
  // getIt.registerSingleton<PreceptRouter>(PreceptRouter());
}

themeInjectionBindings() {
  getIt.registerSingleton<ThemeLookup>(DefaultThemeLookup());
  // getIt.registerFactory<RouteLocatorSet>(() => RouteLocatorSet(locators: null));
}
