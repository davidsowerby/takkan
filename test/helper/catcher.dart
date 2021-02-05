import 'package:test/test.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_script/common/exception.dart';

Matcher throwsBindingException = throwsA(TypeMatcher<BindingException>());
Matcher throwsConfigurationException =
throwsA(TypeMatcher<ConfigurationException>());
Matcher throwsPreceptException = throwsA(TypeMatcher<PreceptException>());
