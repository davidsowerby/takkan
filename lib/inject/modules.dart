import 'package:precept_client/app/router.dart';
import 'package:precept_client/common/locale.dart';
import 'package:precept_client/common/page/signInPage.dart';
import 'package:precept_client/common/toast.dart';
import 'package:precept_client/config/assetLoader.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/library/borderLibrary.dart';
import 'package:precept_client/library/themeLookup.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/signin/signIn.dart';


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
}

libraryInjectionBindings() {
  getIt.registerSingleton<BorderLibrary>(BorderLibrary(modules: [PreceptBorderLibraryModule()]));
}

documentInjectionBindings(){
  getIt.registerFactory<TemporaryDocument>(() => DefaultTemporaryDocument());
}

routerInjectionBindings(){
  getIt.registerFactory<PreceptRouterConfig>(() => PreceptRouterConfig());
  getIt.registerFactoryParam<SignInPage, PSignInOptions,int>((param1, param2) => DefaultSignInPage(signInOptions: param1));
  getIt.registerSingleton<PreceptRouter>(PreceptRouter());
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
