import 'package:precept_client/common/locale.dart';
import 'package:precept_client/common/toast.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/assembler.dart';
import 'package:precept_client/precept/document/documentController.dart';
import 'package:precept_client/precept/library/borderLibrary.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/model/themeLookup.dart';
import 'package:precept_client/precept/mutable/temporaryDocument.dart';
import 'package:precept_client/precept/router.dart';

common() {
  getIt.registerFactory<LocaleReader>(() => DefaultLocaleReader());
  getIt.registerFactory<TemporaryDocument>(() => DefaultTemporaryDocument());
  getIt.registerFactory<Toast>(() => Toast());
}

precept() {
  getIt.registerFactory<PreceptRouterConfig>(() => PreceptRouterConfig());
  getIt.registerSingleton<PartLibrary>(PartLibrary(modules: [PreceptPartLibraryModule()]));
  getIt.registerSingleton<BorderLibrary>(BorderLibrary(modules: [PreceptBorderLibraryModule()]));
  getIt.registerSingleton<PreceptRouter>(PreceptRouter());
  getIt.registerFactory<PageBuilder>(() => PageBuilder());
  getIt.registerSingleton<DocumentController>(DocumentController());
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
