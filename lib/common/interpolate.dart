import 'package:takkan_client/binding/map_binding.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:validators/validators.dart';

final int backlash = '\\'.codeUnits.single;
const k = '@';

String interpolate(String source, DataContext dataContext,
    ModelBinding modelBinding, Map<String, dynamic> variables) {
  final int q = source.indexOf(k);
  if (q == -1) return source;
  int completedTo = 0;
  final StringBuffer buf = StringBuffer();
  while (completedTo < source.length) {
    int start = source.indexOf(k, completedTo);

    /// if we don't find another variable, write the remainder
    if (start == -1) {
      buf.write(source.substring(completedTo));
      break;
    }
    if (source[start - 1].codeUnits[0] == backlash) {
      buf.write(source.substring(completedTo, start - 1));
      buf.write(k);
      completedTo = start + 1;
    } else {
      buf.write(source.substring(completedTo, start));
      start++;
      bool braced = (source[start] == '{');
      if (braced) start++;
      final int end = _findEnd(source, braced, start);
      if (braced && !(source[end] == '}')) {
        throw TakkanException("Closing '}' missing");
      }
      final expanded =
          _expandFrom(source, start, end, dataContext, modelBinding, variables);
      buf.write(expanded);
      completedTo = (source[end] == '}') ? end + 1 : end;
    }
  }
// if(completedTo < end){
//
// }
  return buf.toString();
}

int _findEnd(String source, bool braced, int start) {
  int i = start;
  int end = i;
  bool found = false;
  while (i < source.length) {
    if (isClosingChar(braced, source[i])) {
      end = i;
      found = true;
      break;
    } else {
      i++;
    }
  }
  end = i;
  return end;
}

bool isClosingChar(bool braced, String s) {
  if (isAlphanumeric(s)) return false;
  return (braced) ? !(s == '.') : true;
}

String _expandFrom(
  String source,
  int start,
  int end,
  DataContext dataContext,
  ModelBinding modelBinding,
  Map<String, dynamic> variables,
) {
  final int s = start;
  final String variablePath = source.substring(s, end);
  final List<String> segments = variablePath.split('.');
  Map<String, dynamic> lookupData = (segments[0] == 'user')
      ? {
          'user': Map<String, dynamic>.from(dataContext.dataProvider.user.data),
        }
      : Map.from(modelBinding.modelBinding(property: segments[0]).read() ?? {});
  lookupData.addAll(variables);
  Map<String, dynamic> lastLevel = lookupData;
  for (int i = 0; i < segments.length - 1; i++) {
    if (!lastLevel.keys.contains(segments[i])) {
      return '$variablePath??';
    }
    lastLevel = lastLevel[segments[i]];
  }
  final variableValue = lastLevel[segments.last] ?? '$variablePath??';
  return variableValue;
}
