import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_script/common/exception.dart';

Matcher throwsBindingException = throwsA(isA<BindingException>());
Matcher throwsConfigurationException =throwsA(isA<ConfigurationException>());
Matcher throwsPreceptException = throwsA(isA<PreceptException>());
