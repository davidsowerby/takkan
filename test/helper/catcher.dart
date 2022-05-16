import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/binding/binding.dart';
import 'package:takkan_client/common/exceptions.dart';
import 'package:takkan_script/common/exception.dart';

Matcher throwsBindingException = throwsA(isA<BindingException>());
Matcher throwsConfigurationException = throwsA(isA<ConfigurationException>());
Matcher throwsTakkanException = throwsA(isA<TakkanException>());
