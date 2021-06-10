import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/exception.dart';

Matcher throwsPreceptException = throwsA(isA<PreceptException>());
