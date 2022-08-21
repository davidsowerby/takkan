// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../common/debug.dart';
import '../common/exception.dart';
import '../common/log.dart';
import '../data/converter/conversion_error_messages.dart';
import '../data/provider/data_provider.dart';
import '../page/page.dart';
import '../schema/schema.dart';
import '../schema/validation/validation_error_messages.dart';
import '../validation/message.dart';
import 'script_element.dart';
import 'takkan_element.dart';
import 'version.dart';
import 'walker.dart';

part 'script.g.dart';

/// The heart of Takkan, this structure describes the the Widgets to use and their layout.
/// It also contains a reference to the [schema] to use.
///
/// [name] must be unique within the scope of where the script will be used.
/// Multiple scripts can be merged
/// [locale] Because a script carries static data, a version is required for each
/// locale in use.  This also limits the amount of translation needed on the client.
/// [nameLocale] is generated automatically and should not be set directly
/// [version] is a combination of an incrementing integer and a tag or label for use
/// by the developer.  It is imperative that this version is maintained correctly,
/// so that Takkan version control can work correctly
/// [schema] describes the data in use, along with validation and permissions.  As
/// an alternative to specifying the schema directly, [schemaSource] can be used to
/// load the schema during application start.
///
/// Pages are defined by a combination of [pages] and [routes].  Most pages can
/// be declared in [pages] without the need to explicitly define a route.  Takkan
/// then constructs the route from the document class and objectId, being displayed
/// and the [TakkanRouter] will display the page correctly. A similar approach is
/// taken for pages based on a list of a document class. Static pages (that is,
/// pages which do not directly use dynamic data) need to be explicitly declared
/// in routes, as a route-page pair. You may also use [routes] for custom pages,
/// or just because you want to!  The [TakkanRouter] first checks for the existence
/// of an entry in [routes], and if none is found, uses a default route.
///
/// Note that if you want two different pages for the same document class, one of them
/// will need an explicit entry in [routes]
///
/// [routeMap] is created during the [init] process and combines the routes
/// defined by [pages] and [routes]
///
/// [dataProvider] is the remote provider of data, for example Back4App.
///
/// [controlEdit] defines where edit controls are placed.  See [ControlEdit]
///
/// - [conversionErrorMessages] TODO
/// - [validationErrorMessages] TODO
/// - [_scriptValidationMessages] are collected during the [validate] process
///
/// See also the [overview](https://takkanblog.co.uk/docs/user-guide/intro) of the User Guide,
/// and the [detailed description](https://takkanblog.co.uk/docs/user-guide/takkan-script) of PScript
///

@JsonSerializable(explicitToJson: true)
class Script extends ScriptElement {
  Script({
    this.conversionErrorMessages =
        const ConversionErrorMessages(patterns: defaultConversionPatterns),
    this.validationErrorMessages = const ValidationErrorMessages(
        typePatterns: defaultValidationErrorMessages),
    this.pages = const [],
    required this.name,
    required this.version,
    this.locale = 'en_GB',
    this.schemaSource,
    required this.schema,
    DataProvider? dataProvider,
    super.controlEdit = ControlEdit.firstLevelPanels,
  }) : super(
          dataProvider: dataProvider ?? NullDataProvider(),
        );

  factory Script.fromJson(Map<String, dynamic> json) => _$ScriptFromJson(json);
  final String name;
  final String locale;
  final Version version;
  String? nameLocale;
  final Schema schema;
  @JsonKey(ignore: true)
  final SchemaSource? schemaSource;
  final List<Page> pages;
  final ConversionErrorMessages conversionErrorMessages;
  @JsonKey(ignore: true)
  final ValidationErrorMessages validationErrorMessages;
  @JsonKey(ignore: true)
  List<ValidationMessage> _scriptValidationMessages =
      List.empty(growable: true);

  final Map<TakkanRoute, Page> _routes = {};

  @override
  Map<String, dynamic> toJson() => _$ScriptToJson(this);

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [
        ...super.props,
        conversionErrorMessages,
        validationErrorMessages,
        pages,
        name,
        version,
        locale,
        schemaSource,
        schema,
        nameLocale,
        _scriptValidationMessages,
        _routes,
      ];

  @override
  String get debugId => name;

  Page? pageFromStringRoute(String route) =>
      routes[TakkanRoute.fromString(route)];

  @JsonKey(ignore: true)
  Map<TakkanRoute, Page> get routeMap => _routes;

  Set<String> get allRoles {
    final counter = RoleVisitor();
    walk([counter]);
    return counter.roles;
  }

  @override
  Script get script => this;

  // String get nameLocale => '$name:$locale';

  static Future<Script> readFromFile(File f) async {
    final encoded = await f.readAsString();
    final jsonMap = json.decode(encoded) as Map<String, dynamic>;
    return Script.fromJson(jsonMap);
  }

  /// Validates the structure and content of the model
  /// If there are validation errors, throws a [TakkanException] if [throwOnFail] is true otherwise
  /// returns the list of validation messages
  List<ValidationMessage> validate(
      {bool throwOnFail = false,
      bool useCaptionsAsIds = true,
      bool logFailures = true}) {
    init(useCaptionsAsIds: useCaptionsAsIds);
    final ValidationWalker walker = ValidationWalker();
    final collector = ValidationWalkerCollector();
    walker.walk(this, collector);
    _scriptValidationMessages = collector.messages;
    if (logFailures || throwOnFail) {
      final StringBuffer buf = StringBuffer();
      for (final ValidationMessage message in _scriptValidationMessages) {
        buf.writeln(message.toString());
      }
      if (_scriptValidationMessages.isEmpty) {
        buf.writeln('No validation errors found in PScript $name');
      }
      if (throwOnFail && _scriptValidationMessages.isNotEmpty) {
        throw TakkanException(buf.toString());
      } else {
        logType(runtimeType).i(buf.toString());
      }
    }

    return _scriptValidationMessages;
  }

  @override
  void doValidate(ValidationWalkerCollector collector) {
    super.doValidate(collector);
    if (routes.isEmpty) {
      collector.messages.add(
          ValidationMessage(item: this, msg: 'must contain at least one page'));
    } else {
      if (routes.containsKey('')) {
        collector.messages.add(ValidationMessage(
            item: this, msg: 'PPage route cannot be an empty String'));
      }
    }
  }

  /// Initialises the script by:
  ///
  /// - setting defaults to avoid the developer always
  /// - setting unique Ids for debugging, and references to access the primary
  /// [Script] and [Schema].
  /// - Class specific initialisation, for example query assembly
  ///
  /// All stages cascade down to the [subElements] using the [walk] method
  /// along with a [Walker] implementation
  ///
  /// This is a three stage process.
  /// 1.  set defaults
  /// 1.  the [parent] and [script] properties are set using [SetParentWalker]
  /// 1.  [doInit] is called for each [TakkanElement}
  ///
  ///
  /// 1.  Set Defaults - these are usually items added automatically, to
  /// avoid the developer having to always declares them - for example default
  /// User and Role [Document]s in [Schema]
  ///
  /// 2.  The [parent] and [script] properties are set next, because some [doInit] calls
  /// require that the [parent] is already set, and it is hard to guarantee that
  /// without making the order of [subElements] critical.
  ///
  /// 3.  [doInit] is called
  ///
  /// If [useCaptionsAsIds] is true:  if [id] is not set, then the caption (or other property, as determined
  /// by each class) is treated as the [id].  See [TakkanElement.doInit] for the processing of ids, and
  /// each see the [doInit] call for each [TakkanElement} type for which property, if any, is used.
  Walkers init({bool useCaptionsAsIds = true}) {
    final defaultsWalker = SetDefaultsWalker();
    final parentWalker = SetParentWalker();
    final parentParams = SetParentWalkerParams(
      parent: NullScriptElement(),
    );

    defaultsWalker.walk(this, EmptyWalkerParams());
    parentWalker.walk(this, parentParams);

    final initWalker = InitWalker();
    final params = InitWalkerParams(
      useCaptionsAsIds: useCaptionsAsIds,
    );
    initWalker.walk(this, params);

    return Walkers(
      parentWalker: parentWalker,
      initWalker: initWalker,
    );
  }

  /// Passes call to all [subElements], and builds [_routes] from [pages]
  @override
  void doInit(InitWalkerParams params) {
    super.doInit(params);
    nameLocale = '$name:$locale';
    setupControlEdit(ControlEdit.inherited);
    _mergeRoutes();
  }

  /// See [TakkanElement.subElements]
  @override
  List<Object> get subElements => [
        schema,
        if (schemaSource != null) schemaSource!,
        ...super.subElements,
        pages,
      ];

  Document documentSchema({required String documentSchemaName}) {
    final Document? documentSchema = schema.documents[documentSchemaName];
    if (documentSchema == null) {
      final String msg = "document schema '$documentSchemaName' not found";
      logType(runtimeType).e(msg);
      throw TakkanException(msg);
    }
    return documentSchema;
  }

  bool get failed => _scriptValidationMessages.isNotEmpty;

  bool get passed => _scriptValidationMessages.isEmpty;

  @override
  String get idAlternative => name;

  void validationOutput() {
    final StringBuffer buf = StringBuffer();
    buf.writeln(
        '============================================================================');
    buf.writeln(
        '=                        Script Validation Failed                         =');
    buf.writeln(
        '============================================================================');
    buf.writeAll(_scriptValidationMessages.map((e) => e.toString()), '\n');
    buf.writeln();
    buf.writeln(
        '============================================================================');
    buf.writeln();
    final String msg = buf.toString();
    logType(runtimeType).e(msg);
    throw TakkanException(msg);
  }

  @override
  DebugNode get debugNode => DebugNode(this,
      List.from(routes.entries.toList().map((e) => (e as Page).debugNode)));

  Future<void> writeToFile(File f) async {
    final jsonMap = toJson();
    final encoded = json.encode(jsonMap);
    await f.writeAsString(encoded);
  }

  /// Creates a lookup list of all routes to pages, regardless of whether they are defined
  /// via [pages] or [routes]
  void _mergeRoutes() {
    for (final Page page in pages) {
      _routes.addAll(page.routeMap);
    }
  }

  Map<TakkanRoute, Page> get routes => _routes;
}

class Walkers {
  const Walkers({required this.initWalker, required this.parentWalker});

  final InitWalker initWalker;
  final SetParentWalker parentWalker;
}
