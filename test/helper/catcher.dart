import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/precept/binding/binding.dart';
import 'package:precept_script/common/exception.dart';
import 'package:test/test.dart';

Matcher throwsBindingException = throwsA(TypeMatcher<BindingException>());
Matcher throwsConfigurationException =
    throwsA(TypeMatcher<ConfigurationException>());
Matcher throwsPreceptException = throwsA(TypeMatcher<PreceptException>());
