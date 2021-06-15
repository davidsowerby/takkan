import 'package:mockito/mockito.dart';
import 'package:precept_backend/backend/dataProvider/dataProvider.dart';
import 'package:precept_backend/backend/dataProvider/dataProviderLibrary.dart';
import 'package:precept_backend/backend/user/preceptUser.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

class FakeDataSource extends Fake implements DataSource {
  bool resetCalled = false;

  @override
  reset() {
    resetCalled = true;
  }
}

class FakeDataBindingWithData extends Fake implements DataBinding {
  ModelBinding get binding => RootBinding(data: data, id: 'x');
  final Map<String, dynamic> data;

  FakeDataBindingWithData(this.data);

  bool validate() => true;
}

class FakeDataBindingWithDataSource extends Fake implements DataBinding {
  final DataSource dataSource;

  FakeDataBindingWithDataSource(this.dataSource);

  @override
  DataSource get activeDataSource => dataSource;
}

class FakeContentBindings extends Fake implements ContentBindings {
  final DataBinding dataBinding;
  final DataSource dataSource;
  final DataProvider dataProvider;

  FakeContentBindings(this.dataBinding, this.dataSource, this.dataProvider);
}

class FakeDataProvider extends Fake implements DataProvider {
  final PFakeDataProvider config;

  PreceptUser user = PreceptUser.fromJson({'name': 'Benny'});

  FakeDataProvider({required this.config});
}

class PFakeDataProvider extends Fake implements PDataProviderBase {
  final String instanceName;
  final PSchema schema;

  PFakeDataProvider({required this.instanceName, required this.schema});

  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {}

  void doValidate(List<ValidationMessage> messages) {}

  static register() {
    dataProviderLibrary.register(
        configType: PFakeDataProvider,
        builder: (config) => FakeDataProvider(config: config as PFakeDataProvider));
  }
}

class FakePreceptSchemaLoader extends Fake implements PreceptSchemaLoader {
  Future<PSchema> load(PSchemaSource source) async {
    return PSchema(name: 'test');
  }
}
