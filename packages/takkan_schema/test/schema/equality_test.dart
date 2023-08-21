/// This automates the process of checking the implementation of [Equatable]
/// across [Script], [Schema] and a couple of supporting classes.
///
/// The intent is not to test [Equatable] itself, but to ensure that  [Equatable.props]
/// has been correctly defined.  For reason described in the comments of
/// [TakkanElement], there are cases where *late* properties are included in
/// the equality, and also cases where definitions are merged into, and quality
/// should be measured against the merge output.
///
/// Specifically, the challenge is to:
///
/// 1. Identify which classes implement Equatable
/// 1. Identify all fields within those classes which could be included in [Equatable.props]
/// 1. Design tests so that where required, some fields can be excluded
/// 1. Provide test output that enables rapid identification of a failure
///
/// dart:mirrors is used for most of this
import 'dart:io';
import 'dart:mirrors';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_schema/schema/common/schema_element.dart';
import 'package:takkan_schema/schema/schema.dart';
import 'package:takkan_schema/takkan/takkan_element.dart';
import 'package:test/test.dart';

void main() {
  group('Equatable Props declaration', () {
    setUpAll(() {});

    tearDownAll(() {});

    setUp(() {});

    tearDown(() {});

    test('output', () async {
      // given

      final List<ClassMirror> result = findSubClasses(SchemaElement);
      result.removeWhere(
          (element) => extractName(element.simpleName).startsWith('_'));
      result.removeWhere((element) => element.isAbstract);
      // when

      // then

      for (final ClassMirror c in result) {
        final variables = c.declarations.values
            .whereType<VariableMirror>()
            .whereNot((element) => element.isStatic)
            .toList();
        final variableNamesFromMirror =
            variables.map((e) => extractName(e.simpleName)).toSet();

        final Set<String> declaredInProps = await sourceValues(c, 'props');
        final Set<String> exclusions = {'constraints', 'validation','_constraints'};

        variableNamesFromMirror
            .removeWhere((element) => exclusions.contains(element));

        /// We should include ...super.props unless either:
        /// - parent is Equatable itself
        /// - no other props have been declared
        final superclass = c.superclass;
        if (superclass != null) {
          if (!superclass.simpleName.toString().contains('Equatable')) {
            if (declaredInProps.isNotEmpty) {
              expect(declaredInProps.contains('...super.props'), isTrue,
                  reason: c.simpleName.toString());
            }
          }
        }

        /// But then remove it as it will not be a variable
        declaredInProps.remove('...super.props');

        final diffMsg =
            diffMessage(c, declaredInProps, variableNamesFromMirror);
        final bool check = const UnorderedIterableEquality<String>()
            .equals(declaredInProps, variableNamesFromMirror);

        expect(check, isTrue, reason: diffMsg);
      }
      expect(result.length, 5);
    });
  });
}

String diffMessage(ClassMirror c, Set<String> declaredInProps,
    Set<String> variableNamesFromMirror) {
  final Set<String> diff1 = declaredInProps.difference(variableNamesFromMirror);
  final Set<String> diff2 = variableNamesFromMirror.difference(declaredInProps);
  final StringBuffer buf = StringBuffer();
  buf.writeln();
  buf.writeln('Equality Match failed');
  buf.writeln();
  buf.writeln('Class: ${extractName(c.simpleName)}');
  buf.writeln();
  if (diff1.isNotEmpty) {
    buf.writeln(
        'Properties declared in "props" but not identified as a field by the Mirror: ');
    buf.writeln(
        '(Have you included inherited fields? If so, they should be removed)');
    buf.writeln();
    buf.writeln(diff1.toString());
    buf.writeln();
    buf.writeln();
  }
  if (diff2.isNotEmpty) {
    buf.writeln('Properties identified as variables, but are not in "props" ');
    buf.writeln(
        '(If this is intentional, ensure these are added to "exclusions" in the test)');
    buf.writeln();
    buf.writeln(diff2.toString());
  }
  return buf.toString();
}

List<ClassMirror> findSubClasses(Type type) {
  final ClassMirror classMirror = reflectClass(type);

  return currentMirrorSystem()
      .libraries
      .values
      .expand((lib) => lib.declarations.values)
      .where((lib) {
        return lib is ClassMirror &&
            lib.isSubclassOf(classMirror) &&
            lib != classMirror;
      })
      .toList()
      .cast();
}

Future<Set<String>> sourceValues(ClassMirror c, String propertyName) async {
  final Symbol s = Symbol(propertyName);
  final propsDeclaration = c.declarations[s];
  if (propsDeclaration == null) {
    return {};
  }
  final pLoc = propsDeclaration.location;
  if (pLoc == null) {
    final String msg = 'Unable to locate source, ${c.simpleName}';
    logName('equality_test').e(msg);
    throw TakkanException(msg);
  }
  return readSource(pLoc, propertyName);
}

Future<Set<String>> readSource(
    SourceLocation sourceLocation, String propertyName) async {
  final uri = sourceLocation.sourceUri;
  final segments = uri.pathSegments.sublist(1);

  final File f = File('lib/${segments.join('/')}');
  final source = await f.readAsLines();

  /// Move to the actual code declaration, ignoring annotations and comments
  int c = sourceLocation.line - 1;
  while (
      source[c].trim().startsWith('@') || source[c].trim().startsWith('//')) {
    c++;
  }

  if (!source[c].contains('List<Object?> get $propertyName')) {
    throw Exception(sourceLocation.sourceUri.toString());
  }
  final extractStart = c;
  while (!source[c].contains(']')) {
    c++;
  }
  final extractEnd = c;
  final linesToParse = source.sublist(extractStart, extractEnd + 1);

  final singleLine = linesToParse.join(' ');
  final ripStart = singleLine.indexOf('[') + 1;

  if (ripStart < 0) {
    throw Exception(uri.toString());
  }
  final ripEnd = singleLine.indexOf(']');
  if (ripEnd < 0) {
    throw Exception(uri.toString());
  }
  final rip = singleLine.substring(ripStart, ripEnd);
  final s = rip.split(',').map((e) => e.trim()).toSet();

  /// remove any empty elements cause by trailing comma usually
  return s.where((element) => element.trim().isNotEmpty).toSet();
}

String extractName(Symbol symbol) {
  final s = symbol.toString().replaceFirst('Symbol("', '');
  final s1 = s.replaceFirst('")', '');
  return s1.trim();
}
