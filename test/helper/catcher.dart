import 'package:precept/common/exceptions.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:test/test.dart';

Matcher throwsBindingException = throwsA(TypeMatcher<BindingException>());
Matcher throwsConfigurationException =
    throwsA(TypeMatcher<ConfigurationException>());
Matcher throwsPreceptException = throwsA(TypeMatcher<PreceptException>());
