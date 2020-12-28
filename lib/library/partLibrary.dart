import 'package:flutter/widgets.dart';
import 'package:precept_client/library/library.dart';
import 'package:precept_client/particle/textParticle.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/particle/pText.dart';

class ParticleLibrary extends Library<Type, Widget, PPart> {
  @override
  setDefaults() {
    entries[PText] = (config) => TextParticle(
          config: config,
        );
  }
}

ParticleLibrary _particleLibrary = ParticleLibrary();

ParticleLibrary get particleLibrary => _particleLibrary;
