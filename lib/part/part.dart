import 'package:flutter/material.dart';
import 'package:takkan_client/common/on_color.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/library/part_library.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:provider/provider.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/part/part.dart';
import 'package:takkan_script/script/script.dart';

enum DisplayType { text, datePicker }

enum SourceDataType { string, int, timestamp, boolean, singleSelect, textBlock }

/// A [ParticleSwitch] combines field level data with the manner in which it is displayed.  It uses an [EditState]
/// instance (from the widget tree above) to determine whether it is in edit or read mode.
///
/// Data is connected directly to the Particles during the process of creating them,
/// see [PartLibrary.constructPart]
///
/// Implementations of Part determine which particles to use, along with configuration
/// from its associated Trait.  A Part implementation also provides a suitable builder.
///
/// The default situation (where [singleParticle] is false), uses two particles (just Widgets),
/// one for read mode and one for edit mode.  For example, a Text Widget is used for reading text,
/// and a [TextBox] for edit mode.
///
///
/// A [readParticle] is always required, and is displayed when in read mode (or the data is static).
/// The [editParticle] is displayed when in edit mode.
///
///
/// If [singleParticle] is true, it signifies that particle makes its own modification in response to
/// the current edit state.  In other words, it takes care of its own presentation when in either edit or read mode.
/// The particle is stored in [readParticle]
///
/// [config] is a [Part] instance, which is contained within a [Script].
///
class ParticleSwitch extends StatelessWidget {
  final Part config;
  final Widget readParticle;
  final Widget? editParticle;
  final bool singleParticle;

  const ParticleSwitch({
    Key? key,
    this.singleParticle = false,
    required this.config,
    this.editParticle,
    required this.readParticle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (singleParticle) return readParticle;

    if (config.isStatic || config.readOnly) {
      return readParticle;
    }
    final EditState editState = Provider.of<EditState>(context);
    if (editParticle != null) {
      return (editState.readMode) ? readParticle : editParticle!;
    } else {
      String msg='EditParticle must not be null at this point';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
  }
}

abstract class PartBuilder<P extends Part,T extends StatelessWidget>{
  T createPart({    required P config,
    required ThemeData theme,
    required DataContext dataContext,
    required DataBinding parentDataBinding,
    OnColor onColor = OnColor.surface,});
}


