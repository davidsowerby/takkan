import 'package:flutter_test/flutter_test.dart';
import 'package:precept_script/common/exception.dart';

final TypeMatcher<Error> isError = isA<Error>();
final Matcher throwsError = throwsA(isError);
final Matcher throwsPreceptException = throwsA(TypeMatcher<PreceptException>());
