import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/library/library.dart';
import 'package:precept_client/precept/panel/panel.dart';
import 'package:precept_script/script/script.dart';

class PanelLibrary extends Library<Type, Widget, PPanel> {

  @override
  setDefaults() {
    entries[PPanel] = (config) => Panel(config: config);
  }
}

PanelLibrary _panelLibrary = PanelLibrary();
PanelLibrary get panelLibrary => _panelLibrary;

