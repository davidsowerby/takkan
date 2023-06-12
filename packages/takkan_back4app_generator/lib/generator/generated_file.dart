import 'dart:convert';
import 'dart:io';

import 'package:characters/characters.dart';
import 'package:takkan_schema/common/version.dart';
import 'package:takkan_schema/data/select/condition/condition.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/schema.dart';

import 'back4app/server_code_structure2.dart';

abstract class GeneratedFile {
  GeneratedFile();

  final List<String> _lines = List<String>.empty(growable: true);

  String get fileName;

  List<String> get lines => _lines;

  String get content => lines.join('\n');

  late VirtualFolder folder;

  Future<File> writeFile(Directory outputDirectory) async {
    final File outputFile = File('${outputDirectory.path}/$fileName');
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await outputFile.create();
    return outputFile.writeAsString(content, flush: true);
  }

  String get path => '${folder.path}/$fileName';
}

abstract class JavaScriptFile extends GeneratedFile {
  JavaScriptFile() : super();
  List<JavaScriptElement> elements = List.empty(growable: true);

  void specify({required List<Schema> schemaVersions});

  @override
  String get fileName;

  @override
  String get content => buf.toString();

  CodeBuffer buf = CodeBuffer();

  void writeToBuffer({required List<Schema> schemaVersions}) {
    specify(schemaVersions: schemaVersions);
    for (final element in elements) {
      element.writeToBuffer(buf, conditions: const OutputConditions());
    }
  }

  @override
  Future<File> writeFile(Directory outputDirectory) async {
    final File outputFile = File('${outputDirectory.path}/$fileName');
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await outputFile.create();
    return outputFile.writeAsString(content, flush: true);
  }

  Future<void> generate({
    required Directory outputDir,
    required List<Schema> schemaVersions,
  }) async {
    writeToBuffer(schemaVersions: schemaVersions);
    await writeFile(outputDir);
  }
}

abstract class JSONFile extends GeneratedFile {
  JSONFile() : super();

  Map<String, dynamic> get json;

  @override
  String get content => jsonEncode(json);
}

class Back4AppSchema {
  const Back4AppSchema();

  Map<String, dynamic> get json => throw UnimplementedError();

  void generate({
    required List<Schema> schemaVersions,
  }) {}
}

/// If [lineEnd] is true, a termination character may be appended. This will
/// use either [positionSeparator] (typically a comma) or if that is null, a
/// termination character specified by an element, or failing that, nothing at all.
///
/// See [CodeBuffer.write]
///
/// [continueLine] signifies that the beginning of this output is part way through a line,
/// and indent spacing should not therefore be applied.
///
class OutputConditions {
  const OutputConditions({
    this.continueLine = false,
    this.lineEnd = true,
    this.positionSeparator,
  });

  OutputConditions copyWith(
      {bool? continueLine, String? positionSeparator, bool? lineEnd}) {
    return OutputConditions(
        positionSeparator: positionSeparator ?? this.positionSeparator,
        continueLine: continueLine ?? this.continueLine,
        lineEnd: lineEnd ?? this.lineEnd);
  }

  final String? positionSeparator;
  final bool continueLine;
  final bool lineEnd;
}

abstract class JavaScriptElement {
  const JavaScriptElement({
    this.blankLinesAfter = 0,
    this.terminator = ';',
  });

  final String terminator;
  final int blankLinesAfter;

  /// [buf] is passed around to build the code in a buffer prior to writing out
  /// to a file.
  ///
  /// [conditions] provide some parameters, see [OutputConditions]
  ///
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions});
}

/// [elementSeparator] is appended at the end of every element, except the last,
/// unless [separateLast] is true.
abstract class Block extends JavaScriptElement {
  Block({
    this.elementSeparator,
    this.separateLast = false,
    super.terminator = '',
    super.blankLinesAfter = 0,
    this.commentsBefore = const [],
  });

  final String? elementSeparator;
  final bool separateLast;
  final List<String> commentsBefore;
  final List<JavaScriptElement> content = List.empty(growable: true);

  String get opening => '{';

  String get closing => '}';

  void createContent();

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    final comment = Comment(commentsBefore);
    createContent();
    if (content.isEmpty) {
      buf.write(
          output: '{}', conditions: conditions.copyWith(continueLine: true));
      return;
    }
    if (comment.isNotEmpty) {
      comment.writeToBuffer(buf, conditions: conditions);
    }
    buf.write(output: opening, conditions: conditions);
    buf.incIndent();

    final lastItem = content.removeLast();
    for (final JavaScriptElement element in content) {
      element.writeToBuffer(
        buf,
        conditions: conditions.copyWith(positionSeparator: elementSeparator),
      );
    }
    lastItem.writeToBuffer(buf,
        conditions: conditions.copyWith(
            positionSeparator: separateLast ? elementSeparator : null));

    buf.decIndent();
    final term = conditions.positionSeparator ?? terminator;
    buf.write(
      output: closing,
      blankLinesAfter: blankLinesAfter,
      elementTerminator: term,
      positionSeparator: conditions.positionSeparator,
      conditions: conditions = conditions.copyWith(continueLine: false),
    );
  }
}

/// Unlike a [Block] which indents its content, a [StatementSet] is just an arbitrary
/// collection of [JavaScriptElement], and makes no attempt to control or influence
/// its contents - it is there to simplify otherwise repetitive coding
class StatementSet extends JavaScriptElement {
  StatementSet({
    this.elements,
    super.blankLinesAfter = 0,
  });

  List<JavaScriptElement> content = List.empty(growable: true);
  final List<JavaScriptElement>? elements;

  void createContent() {
    if (elements != null) {
      content.addAll(elements!);
    }
  }

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    createContent();
    for (final JavaScriptElement element in content) {
      element.writeToBuffer(
        buf,
        conditions: conditions,
      );
    }
  }
}

const indentStep = 4;

class Switch extends Block {
  Switch({required this.param, required this.cases, this.defaultCase})
      : super();

  final List<Case> cases;
  final String param;
  final DefaultCase? defaultCase;

  @override
  String get opening => 'switch ($param) {';

  @override
  void createContent() {
    content.addAll(cases);
    if (defaultCase != null) {
      content.add(defaultCase!);
    }
  }
}

class Case extends Block {
  Case(this.caseValue, this.elements,
      {this.useBreak = true, super.blankLinesAfter});

  final List<JavaScriptElement> elements;
  final dynamic caseValue;
  final bool useBreak;

  @override
  String get opening => 'case ${caseValue.toString()}: {';

  @override
  void createContent() {
    content.addAll(elements);
    if (useBreak) {
      content.add(Statement('break;'));
    }
  }
}

class DefaultCase extends Block {
  DefaultCase(this.elements);

  final List<JavaScriptElement> elements;

  @override
  String get opening => 'default: {';

  @override
  void createContent() {
    content.addAll(elements);
  }
}

class AssignStatement extends JavaScriptElement {
  AssignStatement({
    required this.variableName,
    this.isConst = true,
    required this.value,
  });

  final JavaScriptElement value;
  final String variableName;
  final bool isConst;

  String get statement => '$prefix $variableName = ';

  String get prefix => isConst ? 'const' : 'let';

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    buf.write(
        output: statement, conditions: const OutputConditions(lineEnd: false));
    value.writeToBuffer(buf,
        conditions: conditions.copyWith(continueLine: true));
  }
}

/// Named property within an  object (JObject)
class Property extends JavaScriptElement {
  Property({required this.key, required this.value});

  final String key;
  final JavaScriptElement value;

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    buf.write(
        output: "'$key': ", conditions: const OutputConditions(lineEnd: false));
    value.writeToBuffer(buf,
        conditions: conditions.copyWith(continueLine: true));
  }
}

class JString extends JavaScriptElement {
  JString(this.value);

  final String value;

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    buf.write(output: "'$value'", conditions: conditions);
  }
}

class JLiteral extends JavaScriptElement {
  JLiteral(this.value);

  final String value;

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    buf.write(output: value, conditions: conditions);
  }
}

class JObject extends Block {
  JObject(
      {required this.properties,
      super.blankLinesAfter = 1,
      super.terminator = ';'});

  final List<Property> properties;

  @override
  void createContent() {
    content.addAll(properties);
  }
}

class CLPObject extends Block {
  CLPObject(
      {required this.permissions,
      super.blankLinesAfter = 1,
      super.terminator = ';'})
      : super(elementSeparator: ',');

  final Permissions permissions;
  final List<Property> properties = List.empty(growable: true);

  @override
  void createContent() {
    content.addAll([
      Property(
        key: 'addField',
        value: CLPMethod(
          roles: permissions.addFieldRoles,
          requiresAuthentication: permissions.requiresAddFieldAuthentication,
          isPublic: permissions.isPublic.contains(AccessMethod.addField),
        ),
      ),
      Property(
        key: 'count',
        value: CLPMethod(
          roles: permissions.countRoles,
          requiresAuthentication: permissions.requiresCountAuthentication,
          isPublic: permissions.isPublic.contains(AccessMethod.count),
        ),
      ),
      Property(
        key: 'create',
        value: CLPMethod(
          roles: permissions.createRoles,
          requiresAuthentication: permissions.requiresCreateAuthentication,
          isPublic: permissions.isPublic.contains(AccessMethod.create),
        ),
      ),
      Property(
        key: 'delete',
        value: CLPMethod(
          roles: permissions.deleteRoles,
          requiresAuthentication: permissions.requiresDeleteAuthentication,
          isPublic: permissions.isPublic.contains(AccessMethod.delete),
        ),
      ),
      Property(
        key: 'find',
        value: CLPMethod(
          roles: permissions.findRoles,
          requiresAuthentication: permissions.requiresFindAuthentication,
          isPublic: permissions.isPublic.contains(AccessMethod.find),
        ),
      ),
      Property(
        key: 'get',
        value: CLPMethod(
          roles: permissions.getRoles,
          requiresAuthentication: permissions.requiresGetAuthentication,
          isPublic: permissions.isPublic.contains(AccessMethod.get),
        ),
      ),
      Property(
        key: 'protectedFields',
        value: JObject(properties: [], terminator: ',', blankLinesAfter: 0),
      ),
      Property(
        key: 'update',
        value: CLPMethod(
          roles: permissions.updateRoles,
          requiresAuthentication: permissions.requiresUpdateAuthentication,
          isPublic: permissions.isPublic.contains(AccessMethod.update),
        ),
      ),
    ]);
  }
}

class Comment extends JavaScriptElement {
  Comment(this.comments, {super.blankLinesAfter = 0});

  final List<String> comments;

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    for (final String comment in comments) {
      buf.write(
          output: '// $comment',
          conditions: conditions.copyWith(
            positionSeparator: '',
          ),
          blankLinesAfter: blankLinesAfter);
    }
  }

  bool get isNotEmpty => comments.isNotEmpty;
}

class CLPMethod extends Block {
  CLPMethod({
    required this.roles,
    required this.requiresAuthentication,
    required this.isPublic,
  }) : super(
          elementSeparator: ',',
          separateLast: false,
        );

  final List<String> roles;
  final bool requiresAuthentication;
  final bool isPublic;

  @override
  void createContent() {
    if (isPublic || roles.isEmpty) {
      content.add(Property(key: '*', value: JLiteral('true')));
    } else {
      content.addAll(roles.map((roleName) =>
          Property(key: 'role:$roleName', value: JLiteral('true'))));
    }
    if (requiresAuthentication) {
      content.add(
          Property(key: 'requiresAuthentication', value: JLiteral('true')));
    }
  }
}

class DocumentVersion {
  DocumentVersion(this.document, this.version);

  final Document document;
  final Version version;

  bool containsQuery(String queryName) {
    return document.queries.containsKey(queryName);
  }

  List<Condition<dynamic>> queryConditions(String queryName) {
    return (containsQuery(queryName))
        ? document.query(queryName).conditions
        : [];
  }
}

class ExtractSchemaVersionFromRequest extends StatementSet {
  ExtractSchemaVersionFromRequest({super.blankLinesAfter = 1});

  @override
  void createContent() {
    content.addAll([
      Statement(
          'const schema_version = (request.params) ? (request.params.schema_version) ? parseInt(request.params.schema_version) : b4a.schemaVersion : b4a.schemaVersion'),
    ]);
  }
}

/// [throwOnNull] may be required after [responseOnNull] if [responseOnNull] still
/// does not produce a result
class ExtractFromRequest extends StatementSet {
  ExtractFromRequest(
    this.property, {
    required this.dataType,
    this.isParam = false,
    this.throwOnNull,
    this.doParse = true,
    this.responseOnNull='',
  });

  final String property;
  final bool isParam;
  final String? throwOnNull;
  final Type dataType;
  final bool doParse;
  final String responseOnNull;

  @override
  void createContent() {
    final retrieval = isParam ? 'params.$property' : "object.get('$property')$responseOnNull";
    content.addAll([
      Statement('const ${property}Prop = request.$retrieval'),
      if (throwOnNull != null)
        Statement("if (${property}Prop == null) throw '$throwOnNull';"),
      if (doParse) ParseProperty(property, dataType),
    ]);
  }
}

class Statement extends JavaScriptElement {
  Statement(this.statement, {super.blankLinesAfter = 0});

  final String statement;

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    buf.write(
      output: statement,
      conditions: conditions,
      blankLinesAfter: blankLinesAfter,
      elementTerminator: terminator,
    );
  }
}

class ValidationElement extends StatementSet {
  ValidationElement({required this.field});

  final Field<dynamic,Condition<dynamic>> field;

  @override
  void createContent() {
    content.add(ExtractFromRequest(
      field.name,
      dataType: field.modelType,
      throwOnNull: (field.required) ? 'validation ${field.name}' : null,
      doParse: field.conditions.isNotEmpty && field.required,
      responseOnNull: " ?? ((request.original) ? request.original.get('${field.name}') : null)"
    ));

    if (field.conditions.isNotEmpty) {
      if (field.required) {
        content.addAll(_validationStatements);
      } else {
        content.add(IfBlock(condition: '${field.name}Prop != null', ifContent: [
          ParseProperty.fromField(field),
          ..._validationStatements
        ], elseContent: []));
      }
    }

    ///Blank line between props
    content.add(BlankStatement());
  }

  List<Statement> get _validationStatements {
    final List<Statement> list = List.empty(growable: true);
    for (final Condition<dynamic> c in field.conditions) {
      final operand = (c.operand is String)
          ? "'${c.operand.toString()}'"
          : c.operand.toString();

      final String op = c.operator.operator;
      final operator = (lengthOperations.contains(c.operator))
          ? op.replaceFirst('length', '.length ')
          : ' $op';
      final validation =
          "if (!(${c.field}$operator $operand)) throw 'validation ${field.name}';";
      list.add(Statement(validation));
    }
    return list;
  }
}

class BlankStatement extends Statement {
  BlankStatement() : super('');
}

// class RequiredFieldsCheck extends JavaScriptElement {
//   RequiredFieldsCheck({required this.document});
//
//   final Document document;
//
//   @override
//   void writeOut(CodeBuffer buf) {
//     final required =
//         document.fields.values.where((element) => element.required);
//
//     final names = required.map((e) => e.name).toList();
//     names.sort();
//     final quoted = names.map((e) => "'$e'").toList();
//     final braced = "[${quoted.join(',')}]";
//     buf.writeln('const requiredProps=$braced;');
//     buf.writeln('for (propName in requiredProps){');
//     buf.writeln('const v=request.object.get(propName);');
//     buf.writeln('if (v==null) {');
//     buf.writeln("throw 'validation';");
//     buf.writeln('}');
//     buf.writeln('}');
//   }
// }

// class ParseObjectProperty extends JavaScriptElement {}

/// Extracts the value of [property] from the request object
/// 'Prop' is appended to the property name so that the propertyName itself can
/// be used as the parsed value
class ExtractObjectProperty extends JavaScriptElement {
  ExtractObjectProperty({required this.field});

  final Field<dynamic,Condition<dynamic>> field;

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    buf.write(
      output: "const ${field.name}Prop = request.object.get('${field.name}')",
      conditions: conditions,
    );
  }
}

class ParseProperty extends JavaScriptElement {
  ParseProperty(this.property, this.dataType);

  ParseProperty.fromField(Field<dynamic,Condition<dynamic>> field)
      : property = field.name,
        dataType = field.modelType;
  final String property;
  final dynamic dataType;

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    buf.write(
      output: _parseValue(property, dataType),
      conditions: conditions,
    );
  }

  String _parseType(dynamic dataType) {
    switch (dataType) {
      case int:
        return 'parseInt';
      case String:
        return '';
      default:
        return '';
    }
  }

  String _parseValue(String property, dynamic dataType) {
    final String jsParse = _parseType(dataType);
    return (jsParse.isNotEmpty)
        ? 'const $property = $jsParse(${property}Prop);'
        : 'const $property = ${property}Prop;';
  }
}

class CodeBuffer {
  CodeBuffer({String initial = '', this.indentStep = 4})
      : buf = StringBuffer(initial);
  final StringBuffer buf;
  final int indentStep;
  int _indent = 0;

  void incIndent() {
    _indent++;
  }

  void decIndent() {
    _indent--;
  }

  void write({
    required String output,
    String? positionSeparator,
    required OutputConditions conditions,
    String? elementTerminator,
    int blankLinesAfter = 0,
  }) {
    final terminator = conditions.positionSeparator ?? elementTerminator;
    String out;
    if (output.isNotEmpty) {
      final Characters chars = Characters(output);
      final trailing = conditions.lineEnd
          ? ([';', '{'].contains(chars.last))
              ? ''
              : terminator
          : '';
      final indent =
          conditions.continueLine ? '' : ' ' * (_indent * indentStep);
      out = indent + output + (trailing ?? '');
    } else {
      /// isEmpty
      out = output;
    }
    final endLine = conditions.lineEnd ? '\n' : '';
    buf.write('$out$endLine');
    for (int j = 0; j < blankLinesAfter; j++) {
      buf.writeln();
    }
  }

  @override
  String toString() {
    return buf.toString();
  }
}

class IfBlock extends Block {
  IfBlock({
    required this.condition,
    required this.ifContent,
    required this.elseContent,
  });

  final String condition;
  final List<JavaScriptElement> elseContent;
  final List<JavaScriptElement> ifContent;

  @override
  void createContent() {
    content.addAll(ifContent);
  }

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    buf.write(output: 'if ($condition) {', conditions: conditions);
    buf.incIndent();
    for (final JavaScriptElement statement in ifContent) {
      statement.writeToBuffer(buf, conditions: conditions);
    }
    buf.decIndent();
    buf.write(
        output: (elseContent.isEmpty) ? '}' : '} else {',
        conditions: conditions);
    if (elseContent.isNotEmpty) {
      buf.incIndent();
      for (final JavaScriptElement statement in elseContent) {
        statement.writeToBuffer(buf, conditions: conditions);
      }
      buf.decIndent();
      buf.write(output: '}', conditions: conditions);
    }
  }
}

class ModuleExport extends Block {
  ModuleExport() : super(elementSeparator: ',', terminator: ';');
  final List<String> exports = List.empty(growable: true);

  void addExport(String export) {
    exports.add(export);
  }

  @override
  String get opening => 'module.exports = {';

  @override
  void createContent() {
    for (final String export in exports) {
      content.add(JLiteral('$export: $export'));
    }
  }
}

class RequireStatement extends JavaScriptElement {
  RequireStatement(
      {required this.requiredModule, this.assignment, super.blankLinesAfter});

  final String? assignment;
  final String requiredModule;

  @override
  void writeToBuffer(CodeBuffer buf, {required OutputConditions conditions}) {
    final prelim = (assignment == null) ? '' : 'const $assignment = ';
    buf.write(
      output: "${prelim}require('$requiredModule')",
      conditions: conditions,
      blankLinesAfter: blankLinesAfter,
      elementTerminator: terminator,
    );
  }
}
