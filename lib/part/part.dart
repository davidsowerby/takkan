import 'package:flutter/material.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/library/particleLibrary.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/particle/particle.dart';
import 'package:precept_common/common/log.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';
enum DisplayType { text, datePicker }
enum SourceDataType { string, int, timestamp, boolean, singleSelect, textBlock }

/// A [Part] combines field level data with the manner in which it is displayed.
///
/// [Part] contains exactly one or two [Particle] instances, one for reading data and one for editing data
/// [config] is a [PPart] instance, which is contained within a [PScript].  It has the following properties:
///
/// [isStatic] - if true, the value is taken from [staticData], if false, the value is dynamic data loaded via [property]
/// [staticData] - the value to use if [isStatic] is true. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [caption] - the text to display as a caption.  See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [property] - the property to look up in order to get the data value.  This connects a data binding to the [FullDataBinding] above this [Part]
/// [readOnly] - if true, this part is always in read only mode, regardless of any other settings.  If false, this [Part] will respond to the current edit state of the [EditState] immediately above it.
/// [help] - if non-null a small help icon button will popup when clicked. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [tooltip] - tooltip text. See [Localisation](https://www.preceptblog.co.uk/user-guide/precept-model.html#localisation)
/// [particleHeight] - is set here because both read and edit particles need to be the same height to avoid display 'jumping' when switching between read and edit modes.
///
class Part extends StatefulWidget {
  final PPart config;
  final DataBinding parentBinding;

  const Part({Key key, @required this.config, this.parentBinding = const NoDataBinding()})
      : super(key: key);

  @override
  PartState createState() => PartState();
}

class PartState extends State<Part> with ContentBuilder implements ContentState {
  Widget readParticle;
  Widget editParticle;
  DataSource dataSource;
  DataBinding dataBinding = NoDataBinding();

  PCommon get config => widget.config;

  @override
  void initState() {
    super.initState();
    dataSource = DataSource(widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return doBuild(context, dataSource, widget.config, buildContent);
  }

  @override
  Widget buildContent() {
    if (widget.config.isStatic == IsStatic.yes) {
      if (readParticle == null) {
        readParticle = particleLibrary.findStaticParticle(widget.config);
      }
      return readParticle;
    }

    final EditState editState = Provider.of<EditState>(context);
    final readOnly = widget.config.readOnly || editState.readMode;
    logType(this.runtimeType)
        .d("caption: ${widget.config.caption}, EditState readOnly: ${widget.config.readOnly}");
    if (readOnly) {
      if (readParticle == null) {
        readParticle = particleLibrary.findParticle(widget.parentBinding, widget.config, true);
      }
      return readParticle;
    } else {
      if (editParticle == null) {
        editParticle = particleLibrary.findParticle(widget.parentBinding, widget.config, false);
      }
      return editParticle;
    }
  }
}

/// Common base class for part specific read only options which support [Part]
class ReadOnlyOptions {
  final bool showCaption;
  final bool showColumnHeading;
  final TextStyle style;

  const ReadOnlyOptions(
      {this.showCaption = true, this.style = const TextStyle(), this.showColumnHeading = true});
}

/// Common base class for edit mode options which support [Part]
class EditModeOptions {
  final bool showCaption;
  final bool showColumnHeading;

  const EditModeOptions({this.showCaption = true, this.showColumnHeading = true});
}

class TrueFunction {
  const TrueFunction();

  bool call() {
    return true;
  }
}

