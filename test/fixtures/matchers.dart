import 'package:precept_script/common/exception.dart';
import 'package:test/test.dart';

final TypeMatcher<Error> isError = isA<Error>();
final Matcher throwsError = throwsA(isError);
final Matcher throwsPreceptException = throwsA(TypeMatcher<PreceptException>());
