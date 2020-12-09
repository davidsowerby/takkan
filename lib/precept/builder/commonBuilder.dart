import 'package:flutter/widgets.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/precept/library/pageLibrary.dart';
import 'package:precept_client/precept/library/panelLibrary.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/script/element.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:provider/provider.dart';

mixin CommonBuilder {

  /// [config.isStatic] cannot be edited but might define a Backend or DataSource
  Widget assemble(Widget widget, PCommon config) {

    if (config.isStatic == Triple.yes) {
      return widget;
    }
    if (config.hasEditControl) {
      return ChangeNotifierProvider<EditState>(create: (_) => EditState(), child: widget);
    } else {
      return widget;
    }
  }

  Widget assembleContent({List<DisplayElement> content, bool scrollable}) {
    final List<Widget> children = List();
    for (var element in content) {
      Widget child;
      if (element is PPanel) {
        child = PanelBuilder().build(config: element);
      }
      if (element is PPart) {
        child = PartBuilder().build(callingType: element.runtimeType, config: element);
      }
      children.add(ChangeNotifierProvider<EditState>(create: (_) => EditState(), child: child));
    }
    return (scrollable) ? ListView(children: children) : Column(children: children);
  }
}

class PartBuilder with CommonBuilder {
  /// Assembles the [Part] with appropriate [EditState] etc (see https://www.preceptblog.co.uk/user-guide/widget-tree.html)
  /// Throws a [PreceptException] on failure
  Widget build({@required Type callingType, @required PPart config}) {
    final part = partLibrary.find(callingType, config);
    return assemble(part, config);
  }
}

class PageBuilder with CommonBuilder {
  /// Assembles the [Page] with appropriate [EditState] etc (see https://www.preceptblog.co.uk/user-guide/widget-tree.html)
  /// Throws a [PreceptException] on failure
  Widget build({@required PRoute config}) {
    final pageWidget = pageLibrary.find(config.page.pageType, config.page);
    return assemble(pageWidget, config.page);
  }

  Widget buildContent({@required PPage config}) {
    return assembleContent(content: config.content, scrollable: config.scrollable);
  }
}

class PanelBuilder with CommonBuilder{
  Widget build({@required PPanel config}) {
    final panelWidget = panelLibrary.find(config.runtimeType, config);
    return assemble(panelWidget, config);
  }

  Widget buildContent({@required PPanel config}) {
    return assembleContent(content: config.content, scrollable: config.scrollable);
  }
}
