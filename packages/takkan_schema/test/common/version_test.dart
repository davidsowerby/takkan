import 'package:takkan_schema/common/version.dart';
import 'package:test/test.dart';

void main() {
  group('Version', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('equality', () {
      // given
      const v0 = Version(versionIndex: 0);
      const v1 = Version(versionIndex: 1);
      const v2 = Version(versionIndex: 2);
      const v0Label = Version(versionIndex: 0, label: 'v0');
      const v0Status = Version(versionIndex: 0, status: VersionStatus.deprecated);

      // when

      // then
      expect(v0 == v0, true);
      expect(v0 == v0Label, false);
      expect(v0 == v0Status, false);
      expect(v0 == v1, false);
    });
  });
}
