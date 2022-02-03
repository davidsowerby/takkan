void outJson(
    {required Map<String, dynamic> map, String comma = '', bool root = true}) {
  openBlock();
  for (String key in map.keys) {
    outt('"$key": ');
    final value = map[key]!;
    final comma = (key == map.keys.last) ? '' : ',';
    if (value is Map) {
      if (value.isEmpty) {
        outln('{}$comma');
      } else {
        outJson(
          map: Map<String, dynamic>.from(value),
          comma: comma,
          root: false,
        );
      }
    } else {
      final q = (value is String) ? '"' : '';
      outln('$q${value.toString()}$q$comma');
    }
  }
  final term = root ? ';' : comma;
  closeBlock(terminator: term);
}

String get tab => ' ' * (tabLevel * tabIndent);

List<String> get bufContentAsLines => _buf.toString().split('\n');

StringBuffer _buf = StringBuffer();

resetBuf() {
  _buf.clear();
  tabLevel = 0;
}

/// Place s in [buf] with prepended tab and without appended eol
outt([String s = '']) {
  _buf.write('$tab$s');
}

/// Place s in [buf] without prepended tab and without appended eol
outn([String s = '']) {
  _buf.write(s);
}

/// Place s in [buf] with prepended tab and with appended eol
outlt([String s = '']) {
  _buf.writeln('$tab$s');
}

/// Place s in [buf] without prepended tab and with appended eol
outln([String s = '']) {
  _buf.writeln(s);
}

openBlock() {
  outln('{');
  tabLevel++;
}

closeBlock({String terminator = ''}) {
  tabLevel--;

  outlt('}$terminator');
}

int tabLevel = 0;
int tabIndent = 4;
