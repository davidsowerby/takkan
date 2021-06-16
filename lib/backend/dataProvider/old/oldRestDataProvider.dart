// import 'dart:ui';
//
// import 'package:graphql/client.dart';
// import 'package:precept_backend/backend/dataProvider/dataProviderBase.dart';
// import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
// import 'package:precept_script/data/provider/documentId.dart';
// import 'package:precept_script/data/provider/restDataProvider.dart';
// import 'package:precept_script/query/restQuery.dart';
// import 'package:precept_script/script/script.dart';
//
// class RestDataProvider<CONFIG extends PRestDataProvider> extends DataProvider<CONFIG, PRestQuery> {
//   RestDataProvider({required CONFIG config}) : super(config: config);
//
//   @override
//   DocumentId documentIdFromData(Map<String, dynamic> data) {
//     // TODO: implement documentIdFromData
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<Map<String, dynamic>> getDocument(
//       {required DocumentId documentId, Map<String, dynamic> pageArguments = const {}}) {
//     // TODO: implement getDocument
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<PScript> latestScript(
//       {required Locale locale, required int fromVersion, required String name}) {
//     // TODO: implement latestScript
//     throw UnimplementedError();
//   }
//
//
//   @override
//   Future<QueryResult> uploadPreceptScript(
//       {required PScript script, required Locale locale, bool incrementVersion = false}) {
//     // TODO: implement uploadPreceptScript
//     throw UnimplementedError();
//   }
//
//   static register() {
//     dataProviderLibrary.register(
//         config: PRestDataProvider,
//         builder: (config) => RestDataProvider(config: config as PRestDataProvider));
//   }
// }
