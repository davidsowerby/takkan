import 'package:mockito/mockito.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_backend/backend/data_provider/data_provider.dart';
import 'package:precept_backend/backend/data_provider/data_provider_library.dart';
import 'package:precept_backend/backend/user/precept_user.dart';
import 'package:precept_client/binding/map_binding.dart';
import 'package:precept_client/common/content/content_state.dart';
import 'package:precept_client/data/data_binding.dart';
import 'package:precept_client/data/data_source.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/version.dart';

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

  init(AppConfig appConfig) {}
}

class PFakeDataProvider extends Fake implements PDataProvider {
  final String instanceName;
  final PSchema schema;
  final PConfigSource configSource;

  PFakeDataProvider(
      {required this.instanceName,
      required this.schema,
      required this.configSource});


  static register() {
    dataProviderLibrary.register(
        configType: PFakeDataProvider,
        builder: (config) =>
            FakeDataProvider(config: config as PFakeDataProvider));
  }
}

class FakePreceptSchemaLoader extends Fake implements PreceptSchemaLoader {
  Future<PSchema> load(PSchemaSource source) async {
    return PSchema(name: 'test', version: PVersion(number: 0));
  }
}
