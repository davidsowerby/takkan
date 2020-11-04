import 'package:precept/common/component/heading.dart';

abstract class AbstractSection {

  HelpText get helpText;

}

/// An identifier for instances of [Section], used in a [WizSpecification] to enable one step to 'goto' another
/// [lookupKey] is not often required (see below), but if used, should be unique within the scope of any Wizard likely to use it
/// The [titleKey] is generally all that is required, and of course also displays a title where one is used.  The [lookupKey]
/// should be used when:
/// - No title key is required, and if specified, would cause unwanted display of a title
/// - A title key is not unique within the scope of a Wizard - the [lookupKey] then overrides it
class SectionKey {
  final dynamic lookupKey;
  final dynamic titleKey;

  const SectionKey({this.lookupKey, this.titleKey});

  dynamic get key => lookupKey ?? titleKey;

  @override
  bool operator ==(Object other) => other is SectionKey && other.key == key;

  @override
  int get hashCode => key.hashCode;
}
