import 'package:flutter_test/flutter_test.dart';
import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/common/exceptions.dart';
import 'package:takkan_schema/common/exception.dart';

Matcher throwsBindingException = throwsA(isA<BindingException>());
Matcher throwsConfigurationException = throwsA(isA<ConfigurationException>());
Matcher throwsTakkanException = throwsA(isA<TakkanException>());
