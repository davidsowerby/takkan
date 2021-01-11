import 'package:flutter/material.dart';
import 'package:precept_backend/backend/backend.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/common/contentBuilder.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/library/particleLibrary.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/particle/particle.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/dataSource.dart';
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
  _PartState createState() => _PartState();
}

class _PartState extends State<Part> with ContentBuilder implements ContentState {
  Widget readParticle;
  Widget editParticle;
  DataSource dataSource;

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

// assert(
// staticState ? config.staticData != null : true,
// 'If a Part is static, it must define static text. Remember the `isStatic` setting may have come from a parent Document or Section ',
// );
// assert(!staticState ? config.property != null : true,
// 'If a Part is not static, it must define a property. A property may be an empty String');

class DataSource {
  TemporaryDocument _temporaryDocument;
  PDataSource _dataSource;
  List<GlobalKey<FormState>> _formKeys;
  PDocument _documentSchema;

  DataSource(PContent config) {
    init(config);
  }

  RootBinding get rootBinding => _temporaryDocument.rootBinding;

  PDocument get documentSchema => _documentSchema;

  List<GlobalKey<FormState>> get formKeys => _formKeys;

  init(PContent config) {
    if (config.dataSourceIsDeclared) {
      _temporaryDocument = inject<TemporaryDocument>();
      _dataSource = config.dataSource;
      _formKeys = List();
      _documentSchema = config.schema.documents[_dataSource.document];
    }
  }

  TemporaryDocument get temporaryDocument => _temporaryDocument;

  PDataSource get dataSource => _dataSource;

  /// Stores a key for a Form.
  /// Forms are 'flushed' to the backing data by [flushFormsToModel]
  addForm(GlobalKey<FormState> formKey) {
    formKeys.add(formKey);
    logType(this.runtimeType).d("Holding ${formKeys.length} form keys");
  }

  /// Iterates though form keys registered by Pages, Panels or Parts using the same [temporaryDocument].
  /// Keys are added through [addForm], this method 'saves' the [Form] data -
  /// that is, it transfers data from the [Form] back to the [temporaryDocument] via [Binding]s.
  flushFormsToModel(TemporaryDocument temporaryDocument, List<GlobalKey<FormState>> formKeys) {
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState != null) {
        key.currentState.save();
        logType(this.runtimeType).d("Form saved for $key");
      }
    }
    // TODO: purge those with null current state
  }

  Future<bool> persist(PCommon config) async {
    flushFormsToModel(temporaryDocument, formKeys);
    await _doPersist(config);
    return true;
  }

  _doPersist(PCommon config) async {
    final Backend backend = Backend(config: config.backend);
    return backend.save(
      changedData: temporaryDocument.changes,
      fullData: temporaryDocument.output,
      onSuccess: temporaryDocument.saved,
    );
  }
}

/// Forms a chain of data and schema bindings down the Widget tree
class ContentBindings {
  final ContentBindings parent;
  final ModelBinding modelBinding;
  final PDocument schema;

  const ContentBindings({this.parent, this.modelBinding, this.schema});
}
