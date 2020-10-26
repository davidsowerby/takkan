import 'package:flutter/foundation.dart';
import 'package:precept/backend/common/document.dart';
import 'package:precept/backend/common/documentId.dart';
import 'package:precept/backend/common/response.dart';
import 'package:precept/common/repository.dart';
import 'package:precept/common/toast.dart';
import 'package:precept/inject/inject.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/listBinding.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/mutable/temporaryDocument.dart';

/// A model at the level of a document.  Conceptually, a user only ever views / modifies one document at a time
/// This might mean that a document has to be correlated from multiple sources to be presented as a single entity.
/// In such a case, that correlation should be done on the server, and presented via the [Repository] layer.
///
/// A [DocumentModel] contains [SectionModel] instances to reflect the structure of a document.
///
/// When [canEdit] is true, a [TemporaryDocument] is used to  make a controlled copy and track changes before
/// committing to persistence.
/// When [canEdit] is false, the [rootBinding] references the original data.
///
class DocumentModel {
  static const wizardStepProperty = "wizardStep";
  TemporaryDocument _temporaryDocument;
  final bool canEdit;
  final documentType = DocumentType.standard;
  final List<String> modelProperties;
  final List<String> modelListProperties;
  Map<String, dynamic> _data;

  DocumentModel(
      {@required Map<String, dynamic> data,
      @required this.canEdit,
      String id,
      this.modelProperties = const [],
      this.modelListProperties = const []})
      : assert(data != null) {
    /// Reading json is likely to produce Map<dynamic,dynamic> which messes up type inference, so this is just
    /// about type inference
    _data = Map.from(data);

    /// A returned model may not have every sub-model included, but where it is, the JSON Map<dynamic,dynamic> needs to be
    /// converted to a MAp<String,dynamic>
    for (String modelProperty in modelProperties) {
      if (_data.containsKey(modelProperty)) {
        _data[modelProperty] = Map<String, dynamic>.from(_data[modelProperty]);
      }
    }

    /// We don't actually need a temporary document unless editing, but using it keeps things simple
    _temporaryDocument = inject<TemporaryDocument>();
    _temporaryDocument.updateFromSource(source: _data);
  }

  ModelBinding modelBinding({String property}) {
    return rootBinding.modelBinding(property: property);
  }

  void saved() {
    _temporaryDocument.saved();
  }

  RootBinding get rootBinding => _temporaryDocument.rootBinding;

  /// See [TemporaryDocument.output]
  Map<String, dynamic> get output => _temporaryDocument.output;

  /// See [TemporaryDocument.changes]
  Map<String, dynamic> get changes => _temporaryDocument.changes;

  DocumentId get documentId => inject<DocumentIdConverter>().fromModel(this);

  ListBinding<String> get wizardSteps {
    return rootBinding.listBinding<String>(property: wizardStepProperty);
  }

  /// Returns a [MapBinding] for a dot separated [path] into the document.
  MapBinding documentPath({@required String path}) {
    if (path == null || path.isEmpty) {
      return rootBinding;
    }
    final layers = path.split(".");
    MapBinding map = rootBinding;
    for (String layer in layers) {
      map = map.modelBinding(property: layer);
    }
    return map;
  }

  ListBinding documentPathToList({@required String path}) {
    final layers = path.split(".");
    final listProperty = layers.last;
    layers.removeLast();
    final truncatedPath = layers.join(".");
    final parent = documentPath(path: truncatedPath);
    return parent.listBinding(property: listProperty);
  }

  setWizardSteps(List<String> steps) {
    wizardSteps.write(steps);
  }

  MapBinding sectionModelData(String propertyName) {
    final segments = propertyName.split(".");
    MapBinding binding = rootBinding;
    for (int i = 0; i <= segments.length - 1; i++) {
      binding = binding.modelBinding(property: segments[i]);
    }
    return binding;
  }

  /// Persists the [_temporaryDocument] using the [Repository]
  ///
  /// Note that this DOES NOT flush any changes from Forms into the model.  That would need to be done prior to this call
  /// if required
  ///
  Future<CloudResponse> saveDocument() async {
    final response = await BaseRepository().saveDocument(model: this);
    snackToast(text: "Changes saved");
    return response;
  }
}

class TitledDocumentModel extends DocumentModel {
  TitledDocumentModel(
      {@required Map<String, dynamic> data, String id, bool canEdit})
      : super(data: data, id: id, canEdit: canEdit);

  StringBinding get title {
    return rootBinding.stringBinding(property: "title");
  }

  StringBinding get subtitle {
    return rootBinding.stringBinding(property: "subtitle");
  }
}


