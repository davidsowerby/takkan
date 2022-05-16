import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takkan_client/binding/map_binding.dart';
import 'package:takkan_client/common/toast.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/data/document_cache.dart';
import 'package:takkan_client/library/part_library.dart';
import 'package:takkan_client/panel/panel.dart';
import 'package:takkan_client/pod/data_root.dart';
import 'package:takkan_backend/backend/app/app_config.dart';
import 'package:takkan_backend/backend/data_provider/data_provider.dart';
import 'package:takkan_backend/backend/data_provider/data_provider_library.dart';
import 'package:takkan_backend/backend/data_provider/result.dart';
import 'package:takkan_script/data/provider/document_id.dart';
import 'package:takkan_script/schema/schema.dart';

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

class MockDocument extends Mock implements Document {}

class MockDataProvider extends Mock implements IDataProvider {}

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
  final IDataProvider dataProvider;
  final DocumentClassCache classCache;
  final Document documentSchema;

  MockDataContextWithParams({
    IDataProvider? dataProvider,
    DocumentClassCache? classCache,
    Document? documentSchema,
  })  : dataProvider = dataProvider ?? MockDataProvider(),
        documentSchema = documentSchema ?? MockDocument(),
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
class MockPanel extends Mock
    with Diagnosticable
    implements Widget, PanelWidget {}
