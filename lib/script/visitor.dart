
import 'package:precept_script/script/preceptItem.dart';

/// Used to 'walk' a [PScript].  It is invoked at every entry within the [PScript], by invoking
/// [PScript.walk]. It simply returns the entry. It is up to the implementation of this interface to
/// decide what do with the entry.
abstract class ScriptVisitor{
   step(PreceptItem entry);
}