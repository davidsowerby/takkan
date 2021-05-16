import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/debug.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/element.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/converter/conversionErrorMessages.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/panel/panelStyle.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/query/queryConverter.dart';
import 'package:precept_script/schema/validation/validationErrorMessages.dart';
import 'package:precept_script/trait/textTrait.dart';
import 'package:precept_script/validation/message.dart';

part 'script.g.dart';

/// The heart of Precept, this structure describes the the Widgets to use and their layout.
///
/// For more see the [overview](https://www.preceptblog.co.uk/user-guide/#overview) of the User Guide,
/// and the [detailed description](https://www.preceptblog.co.uk/user-guide/precept-script.html#introduction) of PScript
/// - [_scriptValidationMessages] are collected during the [validate] process
@JsonSerializable(nullable: false, explicitToJson: true)
class PScript extends PCommon {
  final String name;
  final Map<String, PPage> pages;
  final ConversionErrorMessages conversionErrorMessages;
  @JsonKey(ignore: true)
  final ValidationErrorMessages validationErrorMessages;
  @JsonKey(ignore: true)
  List<ValidationMessage> _scriptValidationMessages;

  PScript({
    this.conversionErrorMessages = const ConversionErrorMessages(defaultConversionPatterns),
    this.validationErrorMessages = const ValidationErrorMessages(defaultValidationErrorMessages),
    this.pages = const {},
    this.name,
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle = const PPanelStyle(),
    PTextTrait textTrait = const PTextTrait(),
    ControlEdit controlEdit = ControlEdit.firstLevelPanels,
    String id,
  }) : super(
          id: id,
          isStatic: isStatic,
          dataProvider: dataProvider ?? PNoDataProvider(),
          query: query,
          controlEdit: controlEdit,
          textTrait: textTrait,
        );

  factory PScript.fromJson(Map<String, dynamic> json) => _$PScriptFromJson(json);

  Map<String, dynamic> toJson() => _$PScriptToJson(this);

  /// We have to override here, because the inherited getter looks to the parent - but now we do not have a parent
  @override
  @JsonKey(
      fromJson: PQueryConverter.fromJson,
      toJson: PQueryConverter.toJson,
      nullable: true,
      includeIfNull: false)
  PQuery get query => getQuery();

  /// We have to override these here, because the inherited getter looks to the parent - but now we do not have a parent
  IsStatic get isStatic => getIsStatic();

  /// Validates the structure and content of the model
  /// If there are validation errors, throws a [PreceptException] if [throwOnFail] is true otherwise
  /// returns the list of validation messages
  List<ValidationMessage> validate(
      {bool throwOnFail = false, bool useCaptionsAsIds = true, bool logFailures = true}) {
    init(useCaptionsAsIds: useCaptionsAsIds);
    _scriptValidationMessages = List.empty(growable: true);
    doValidate(_scriptValidationMessages);

    if (pages == null || pages.length == 0) {
      _scriptValidationMessages
          .add(ValidationMessage(item: this, msg: "must contain at least one component"));
    } else {
      for (var entry in pages.entries) {
        if (entry.key.isEmpty) {
          _scriptValidationMessages
              .add(ValidationMessage(item: this, msg: "PPage route cannot be an empty String"));
        }
        entry.value.doValidate(_scriptValidationMessages);
      }
    }

    if (conversionErrorMessages == null) {
      _scriptValidationMessages.add(ValidationMessage(
          item: this,
          msg:
              "conversionErrorMessages must be provided, they are required for data conversion error messages"));
    }

    if (validationErrorMessages == null) {
      _scriptValidationMessages.add(ValidationMessage(
          item: this,
          msg:
              "validationErrorMessages must be provided, they are required for data validation error messages"));
    }

    if (logFailures || throwOnFail) {
      final StringBuffer buf = StringBuffer();
      for (ValidationMessage message in _scriptValidationMessages) {
        buf.writeln(message.toString());
      }
      if (_scriptValidationMessages.isEmpty) {
        buf.writeln('No validation errors found in PScript $name');
      }
      if (throwOnFail && _scriptValidationMessages.isNotEmpty) {
        throw PreceptException(buf.toString());
      } else {
        logType(this.runtimeType).i(buf.toString());
      }
    }

    return _scriptValidationMessages;
  }

  /// Initialises the script by setting up a variety of variables which can be derived from those explicitly set by the user
  /// See the [doInit] call for each [PreceptItem} type
  ///
  /// If [useCaptionsAsIds] is true:  if [id] is not set, then the caption (or other property, as determined
  /// by each class) is treated as the [id].  See [PreceptItem.doInit] for the processing of ids, and
  /// each see the [doInit] call for each [PreceptItem} type for which property, if any, is used.
  init({bool useCaptionsAsIds = true}) {
    doInit(this, null, 0, useCaptionsAsIds: useCaptionsAsIds);
  }

  /// Passes call to all components, and sets the [PPage.route] the keys in [pages]
  @override
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, null, 0);
    setupControlEdit(ControlEdit.inherited);
    int i = 0;
    for (var entry in pages.entries) {
      entry.value.route = entry.key;

      /// This must be done first or validation messages get wrong debugId
      entry.value.doInit(script, this, i, useCaptionsAsIds: useCaptionsAsIds);
      i++;
    }
  }

  /// Walks through all instances of [PreceptItem] or its sub-classes held within the [PScript].
  /// At each instance, the [ScriptVisitor.step] is invoked
  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    for (PPage entry in pages.values) {
      entry.walk(visitors);
    }
  }

  bool get failed => _scriptValidationMessages.length > 0;

  bool get passed => _scriptValidationMessages.length == 0;

  String get idAlternative => name;

  validationOutput() {
    StringBuffer buf = StringBuffer();
    buf.writeln('============================================================================');
    buf.writeln('=                        PScript Validation Failed                         =');
    buf.writeln('============================================================================');
    buf.writeAll(_scriptValidationMessages.map((e) => e.toString()), '\n');
    buf.writeln();
    buf.writeln('============================================================================');
    buf.writeln();
    print(buf.toString());
  }

  DebugNode get debugNode =>
      DebugNode(this, List.from(pages.entries.toList().map((e) => (e as PPage).debugNode)));
}

/// [pageType] is used to look up from [PageLibrary]
/// although [content] is a list, this simplest page only uses the first one
/// [route] is set during script initialisation
@JsonSerializable(nullable: true, explicitToJson: true)
class PPage extends PContent {
  final String pageType;
  final bool scrollable;
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<PSubContent> content;
  final PPageLayout layout;
  @JsonKey(ignore: true)
  String route;

  // @JsonKey(ignore: true)
  PPage({
    this.pageType = 'defaultPage',
    this.scrollable = true,
    this.layout=const PPageLayout(),
    IsStatic isStatic = IsStatic.inherited,
    this.content = const [],
    PDataProvider dataProvider,
    PQuery query,
    ControlEdit controlEdit = ControlEdit.inherited,
    String id,
    String property,
    @required String title,
  }) : super(
          isStatic: isStatic,
          dataProvider: dataProvider,
          query: query,
          controlEdit: controlEdit,
          id: id,
          property: property,
          caption: title,
        );

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  PScript get parent => super.parent as PScript;

  DebugNode get debugNode {
    final List<DebugNode> children = content.map((e) => e.debugNode).toList();
    if (dataProviderIsDeclared) {
      children.add(dataProvider.debugNode);
    }
    if (queryIsDeclared) {
      children.add(query.debugNode);
    }
    return DebugNode(this, children);
  }

  Map<String, dynamic> toJson() => _$PPageToJson(this);

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    if (title == null || title.isEmpty) {
      messages.add(ValidationMessage(
        item: this,
        msg: 'must define a title',
      ));
    }
    if (pageType == null || pageType.isEmpty) {
      messages.add(ValidationMessage(
        item: this,
        msg: 'must define a pageType',
      ));
    }

    for (var element in content) {
      if (element is PCommon) {
        element.doValidate(messages);
      }
    }
  }

  @override
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    int i = 0;
    for (var element in content) {
      if (element is PPanel) {
        element.doInit(script, this, i, useCaptionsAsIds: useCaptionsAsIds);
      }
      if (element is PPart) {
        element.doInit(script, this, i, useCaptionsAsIds: useCaptionsAsIds);
      }
      i++;
    }
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    for (PSubContent entry in content) {
      entry.walk(visitors);
    }
  }

  @override
  String get idAlternative => title;

  String get title => caption;

  /// [dataProvider] is always
  /// considered 'declared' by the page, if any level above it actually declares it.
  /// This is because a page is the first level to be actually built into the Widget tree
  bool get dataProviderIsDeclared => (dataProvider != null && !(dataProvider is PNoDataProvider));

  /// [query] is always
  /// considered 'declared' by the page, if any level above it actually declares it.
  /// This is because a page is the first level to be actually built into the Widget tree
  bool get queryIsDeclared => query != null;
}

enum PageType { standard }

/// property || documentSelector must be non-null
/// parts || sections must be non empty

//







