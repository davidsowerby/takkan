import 'package:precept_backend/backend/backend.dart';
import 'package:precept_backend/backend/backendLibrary.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/document.dart';
import 'package:precept_backend/backend/query/query.dart';
import 'package:precept_backend/backend/response.dart';
import 'package:precept_script/script/backend.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/documentId.dart';
import 'package:test/test.dart';

import '../matchers.dart';

void main() {
  group('BackendLibrary', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('two instances', () {
      // given
      backendLibrary.register(
          config: PTestBackend, builder: (config) => TestBackend(config: config));
      // when
      final b1 = backendLibrary.find(config: PTestBackend());
      final b2 = backendLibrary.find(config: PTestBackend(instanceName: 'second'));
      // then
      expect(b1.config.instanceName, 'default');
      expect(b2.config.instanceName, 'second');
    });
    test('builder not registered', () {
      // given
      backendLibrary.clear();
      // when

      // then

      expect(() => backendLibrary.find(config: PTestBackend()), throwsPreceptException);
    });
  });
}

class PTestBackend2 extends PBackend {
  PTestBackend2({String instanceName = 'default', PTestBackend config})
      : super(instanceName: instanceName, connection: {});
}

class PTestBackend extends PBackend {
  PTestBackend({String instanceName = 'default', PTestBackend config})
      : super(instanceName: instanceName, connection: {});
}

class TestBackend extends Backend {
  TestBackend({PTestBackend config}) : super(config: config);

  @override
  Future<CloudResponse> delete({List<DocumentId> documentIds}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> executeFunction({String functionName, Map<String, dynamic> params}) {
    // TODO: implement executeFunction
    throw UnimplementedError();
  }

  @override
  Future<bool> exists({DocumentId documentId}) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  Future<Data> fetch({String functionName, DocumentId documentId}) {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<Data> fetchDistinct({String functionName, Map<String, dynamic> params}) {
    // TODO: implement fetchDistinct
    throw UnimplementedError();
  }

  @override
  Future<List<Data>> fetchList({functionName, Map<String, String> params}) {
    // TODO: implement fetchList
    throw UnimplementedError();
  }

  @override
  Future<Data> get({PDataGet query}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Data> getDistinct({Query query}) {
    // TODO: implement getDistinct
    throw UnimplementedError();
  }

  @override
  Stream<Data> getDistinctStream({Query query}) {
    // TODO: implement getDistinctStream
    throw UnimplementedError();
  }

  @override
  Future<Data> getList({Query query}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Stream<List<Data>> getListStream({Query query}) {
    // TODO: implement getListStream
    throw UnimplementedError();
  }

  @override
  Stream<Data> getStream({DocumentId documentId}) {
    // TODO: implement getStream
    throw UnimplementedError();
  }

  @override
  Future<CloudResponse> save(
      {DocumentId documentId,
      Map<String, dynamic> changedData,
      Map<String, dynamic> fullData,
      DocumentType documentType = DocumentType.standard,
      bool saveChangesOnly = true,
      Function() onSuccess}) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
