// import 'dart:convert';
// import 'dart:io';
//
// import 'package:takkan_back4app_client/backend/back4app/provider/data_provider.dart';
// import 'package:takkan_backend/backend/app/app_config.dart';
// import 'package:takkan_backend/backend/app/app_config_loader.dart';
// import 'package:takkan_script/data/provider/data_provider.dart';
// import 'package:takkan_script/schema/schema.dart';
// import 'package:takkan_script/script/version.dart';
// import 'package:test/test.dart';
//
// import '../../fixture.dart';
//
// void main() async{
//   AppConfigFileLoader loader = AppConfigFileLoader();
//   AppConfig appConfig = await loader.load();
//   group('Testing reference code', () {
//     setUpAll(() {
//       final Back4AppDataProvider providerConfig = Back4AppDataProvider(
//         configSource: ConfigSource(segment: 'main', instance: 'dev'),
//         schema: Schema(
//             name: 'test',
//             version: Version(number: 0),
//             documents: {'PreceptScript': pScriptSchema0}),
//       );
//
//       provider = Back4AppDataProvider(config: providerConfig);
//       provider?.init(appConfig);
//     });
//
//     tearDownAll(() {});
//
//     setUp(() {});
//
//     tearDown(() {});
//
//     /// Version 0 also tests framework.js.  That does not change between versions
//     /// and therefore only needs testing once
//     test('version 0', () async {
//       // given code deployed
//       await prepareFrameworkTest(version: 0, callInitPrecept: false);
//       // when
//       final applySchemaResponse = await execute(
//         function: 'applyServerSchema',
//         params: {
//           'version': 0,
//         },
//       );
//       // then
//       expect(1, 1);
//     }, timeout: Timeout(Duration(minutes: 1)));
//   });
// }
