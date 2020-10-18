import 'package:precept/common/locale.dart';
import 'package:precept/common/toast.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';

common() {
  getIt.registerFactory<LocaleReader>(() => DefaultLocaleReader());
  getIt.registerFactory<TemporaryDocument>(() => DefaultTemporaryDocument());
  getIt.registerFactory<Toast>(() => Toast());
}

precept() {
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
