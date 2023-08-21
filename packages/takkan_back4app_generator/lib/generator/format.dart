class Formatter {

  final StringBuffer _buf = StringBuffer();
  int tabLevel = 0;
  int tabIndent = 4;

  void outJson({required Map<String,
      dynamic> map, String comma = '', bool root = true}) {
    openBlock();
    for (final String key in map.keys) {
      outt('"$key": ');
      final value = map[key];
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
        outln('$q$value$q$comma');
      }
    }
    final term = root ? ';' : comma;
    closeBlock(terminator: term);
  }

  String get tab => ' ' * (tabLevel * tabIndent);

  List<String> get bufContentAsLines => _buf.toString().split('\n');



  void resetBuf() {
    _buf.clear();
    tabLevel = 0;
  }

  /// Place s in [buf] with prepended tab and without appended eol
  void outt([String s = '']) {
    _buf.write('$tab$s');
  }

  /// Place s in [buf] without prepended tab and without appended eol
  void outn([String s = '']) {
    _buf.write(s);
  }

  /// Place s in [buf] with prepended tab and with appended eol
  void outlt([String s = '']) {
    _buf.writeln('$tab$s');
  }

  /// Place s in [buf] without prepended tab and with appended eol
  void outln([String s = '']) {
    _buf.writeln(s);
  }

  void openBlock() {
    outln('{');
    tabLevel++;
  }

  void  closeBlock({String terminator = ''}) {
    tabLevel--;

    outlt('}$terminator');
  }


}
