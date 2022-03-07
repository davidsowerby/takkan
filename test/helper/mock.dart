import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_backend/backend/data_provider/result.dart';
import 'package:precept_client/binding/map_binding.dart';
import 'package:precept_client/common/toast.dart';
import 'package:precept_client/data/cache_entry.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_client/data/document_cache.dart';
import 'package:precept_client/library/part_library.dart';
import 'package:precept_client/panel/panel.dart';
import 'package:precept_client/pod/data_root.dart';
import 'package:precept_script/data/provider/document_id.dart';
import 'package:precept_script/schema/schema.dart';

class MockBuildContext extends Mock implements BuildContext {
  @override
  BuildOwner get owner => MockBuildOwner();
}

class MockBuildOwner extends Mock implements BuildOwner {
  @override
  bool get debugBuilding => true;
}

class MockToast extends Mock implements Toast {}

class MockAppConfig extends Mock implements AppConfig {}

class MockDocumentRoot extends Mock implements DocumentRoot {}

class MockPDocument extends Mock implements PDocument {}

class MockDataProvider extends Mock implements DataProvider {}

class MockDataProviderLibrary extends Mock implements DataProviderLibrary {}

class MockPartLibrary extends Mock implements PartLibrary {}

class MockDocumentCache extends Mock implements DocumentCache {}

class MockDocumentClassCache extends Mock implements DocumentClassCache {}

class MockModelBinding extends Mock implements ModelBinding {}

class MockDataBinding extends Mock implements DataBinding {}

class MockDataContext extends Mock implements DataContext {}

class MockCreateResult extends Mock implements CreateResult {}

class MockUpdateResult extends Mock implements UpdateResult {}

class MockReadResultItem extends Mock implements ReadResultItem {}

class MockDataContextWithParams implements DataContext {
  final DataProvider dataProvider;
  final DocumentClassCache classCache;
  final PDocument documentSchema;

  MockDataContextWithParams({
    DataProvider? dataProvider,
    DocumentClassCache? classCache,
    PDocument? documentSchema,
  })  : dataProvider = dataProvider ?? MockDataProvider(),
        documentSchema = documentSchema ?? MockPDocument(),
        classCache = classCache ?? MockDocumentClassCache();
}

// class MockUserDiscardChangesPrompt extends Mock
//     implements UserDiscardChangesPrompt {}
//
// class MockUserDeleteDocumentPrompt extends Mock
//     implements UserDeleteDocumentPrompt {}

class FakeDocumentId extends Fake implements DocumentId {}

// class MockUserState extends Mock implements UserState{}
// ignore: must_be_immutable
class MockPanel extends Mock with Diagnosticable implements Widget, Panel {}
