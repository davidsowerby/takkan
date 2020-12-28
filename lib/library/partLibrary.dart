import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/converter.dart';
import 'package:precept_client/particle/textParticle.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/particle/pText.dart';

ParticleLibrary _particleLibrary = ParticleLibrary();

ParticleLibrary get particleLibrary => _particleLibrary;

class ParticleLibrary {
  final Map<Type, Widget Function(PPart, ModelConnector)> entries = Map();

  ParticleLibrary();

  /// Finds an entry in the library matching [key], and returns an instance of it with [config]
  /// Throws a [PreceptException] if not found
  Widget find(Type key, PPart config, ModelConnector connector) {
    logType(this.runtimeType).d("Finding $key in $runtimeType");
    final func = entries[key];
    if (func == null) {
      String msg = "No entry is defined for ${key.toString()} in $runtimeType";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return (func == null) ? null : func(config, connector);
  }

  /// Loads library entries defined by the developer
  ///
  /// If there are duplicate keys, later additions will override earlier
  /// Defaults are loaded first, so to replace, define another with the key 'default'
  /// There should be no need to call this directly, init for all libraries is carried out in
  /// a call to [Precept.init] which should be before your runApp statement
  init({Map<Type, Widget Function(PPart, ModelConnector)> entries}) {
    setDefaults();

    if (entries != null) {
      this.entries.addAll(entries);
    }
    logType(this.runtimeType).d("$runtimeType Library initialised");
  }

  setDefaults() {
    entries[PText] = (config, connector) =>
        TextParticle(
          config: config,
          connector: connector,
        );
  }
}
