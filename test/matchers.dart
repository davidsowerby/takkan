import 'package:precept_script/common/exception.dart';
import 'package:test/test.dart';

Matcher throwsPreceptException = throwsA(TypeMatcher<PreceptException>());