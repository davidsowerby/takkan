import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:test/test.dart';

import '../matchers.dart';

// void main() {
//   group('BackendLibrary', () {
//     setUpAll(() {});
//
//     tearDownAll(() {});
//
//     setUp(() {});
//
//     tearDown(() {});
//
//     test('multiple instances, instanceName and env', () {
//       // given
//       dataProviderLibrary.register(
//           config: PTestBackend, builder: (config) => TestBackend(config: config));
//
//       // when
//       final b1 = dataProviderLibrary.find(config: PTestBackend());
//       final b2 = dataProviderLibrary.find(config: PTestBackend(instanceName: 'second'));
//       final b3 = dataProviderLibrary.find(config: PTestBackend(env: Env.prod));
//       final b4 = dataProviderLibrary.find(config: PTestBackend(env: Env.prod, instanceName: 'third'));
//       // then
//       expect(b1.config.instanceName, 'default');
//       expect(b2.config.instanceName, 'second');
//       expect(b3.config.instanceName, 'Env.prod');
//       expect(b3.config.env, Env.prod);
//       expect(b4.config.instanceName, 'third');
//     });
//
//     test('builder not registered', () {
//       // given
//       backendLibrary.clear();
//       // when
//
//       // then
//
//       expect(() => backendLibrary.find(config: PTestBackend()), throwsPreceptException);
//     });
//
//   });
// }
//
// class PTestBackend2 extends PBackend {
//   PTestBackend2({String instanceName , PTestBackend config, Env env})
//       : super(instanceName: instanceName, connectionData: {}, env:env);
// }
//
// class PTestBackend extends PBackend {
//   PTestBackend({String instanceName, PTestBackend config, Env env})
//       : super(instanceName: instanceName, connectionData: {}, env: env);
// }
//
// class TestBackend extends Backend {
//   TestBackend({PTestBackend config}) : super(config: config);
//
//   @override
//   Future<CloudResponse> delete({List<DocumentId> documentIds}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<CloudResponse> executeFunction({String functionName, Map<String, dynamic> params}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<bool> exists({DocumentId documentId}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<Data> fetch({String functionName, DocumentId documentId}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<Data> fetchDistinct({String functionName, Map<String, dynamic> params}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<Data>> fetchList({functionName, Map<String, String> params}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<Data> get({PDataGet query}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<Data> getDistinct({Query query}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Stream<Data> getDistinctStream({Query query}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<Data> getList({Query query}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Stream<List<Data>> getListStream({Query query}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Stream<Data> getStream({DocumentId documentId}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<CloudResponse> save(
//       {DocumentId documentId,
//       Map<String, dynamic> changedData,
//       Map<String, dynamic> fullData,
//       DocumentType documentType = DocumentType.standard,
//       bool saveChangesOnly = true,
//       Function() onSuccess}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   doConnect() async {
//     return true;
//   }
// }
