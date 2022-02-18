import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_client/app/router.dart';
import 'package:precept_client/common/locale.dart';
import 'package:precept_client/common/page/signin_page.dart';
import 'package:precept_client/common/toast.dart';
import 'package:precept_client/config/asset_loader.dart';
import 'package:precept_client/data/temporary_document.dart';
import 'package:precept_client/library/border_library.dart';
import 'package:precept_client/library/theme_lookup.dart';
import 'package:precept_client/user/signin_factory.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/signin/sign_in.dart';

void preceptDefaultInjectionBindings() {
  commonInjectionBindings();
  libraryInjectionBindings();
  documentInjectionBindings();
  routerInjectionBindings();
  themeInjectionBindings();
}

commonInjectionBindings() {
  getIt.registerFactory<LocaleReader>(() => DefaultLocaleReader());
  getIt.registerFactory<Toast>(() => Toast());
  getIt.registerFactory<JsonAssetLoader>(() => DefaultJsonAssetLoader());
  getIt.registerFactory<SignInFactory>(() => DefaultSignInFactory());
  getIt.registerFactory<EmailSignInFactory>(() => DefaultEmailSignInFactory());
}

libraryInjectionBindings() {
  getIt.registerSingleton<BorderLibrary>(BorderLibrary(modules: [PreceptBorderLibraryModule()]));
}

documentInjectionBindings(){
  getIt.registerFactory<MutableDocument>(() => DefaultMutableDocument());
}

routerInjectionBindings(){
  getIt.registerFactory<PreceptRouterConfig>(() => PreceptRouterConfig());
  getIt.registerFactoryParam<SignInPage, PSignInOptions,int>((param1, param2) => DefaultSignInPage(dataProvider: param1 as DataProvider, pageArguments: param2 as Map<String,dynamic>,));
  // getIt.registerSingleton<PreceptRouter>(PreceptRouter());
}

themeInjectionBindings() {
  getIt.registerSingleton<ThemeLookup>(DefaultThemeLookup());
  // getIt.registerFactory<RouteLocatorSet>(() => RouteLocatorSet(locators: null));
}


// void back4AppModule() {
//   getIt.registerFactory<BackendInitialiser>(() => Back4AppInitialiser());
//   getIt.registerFactory<BackendConfig>(() => Back4AppBackendConfig());
//   getIt.registerFactory<SignInOut>(() => Back4AppSignInOut());
//   getIt.registerFactory<BackendDelegate>(() => Back4AppBackendDelegate());
//   getIt.registerFactory<DocumentIdConverter>(() => Back4AppDocumentIdConverter());
// }
//
// void firebaseModule() {
//   getIt.registerFactory<SignInOut>(() => FirebaseSignInOut());
//   getIt.registerFactory<BackendInitialiser>(() => FirebaseInitialiser());
//   getIt.registerFactory<BackendConfig>(() => FirebaseBackendConfig());
//   getIt.registerFactory<BackendDelegate>(() => FirebaseBackendDelegate());
//   getIt.registerFactory<DocumentIdConverter>(() => FirebaseDocumentIdConverter());
//   if (kIsWeb) {
//     getIt.registerFactory<RemoteConfigWrapper>(() => WebRemoteConfigWrapper());
//   } else {
//     getIt.registerFactory<RemoteConfigWrapper>(() => DefaultRemoteConfigWrapper());
//   }
// }
