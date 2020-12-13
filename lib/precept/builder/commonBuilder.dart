import 'package:flutter/widgets.dart';
import 'package:precept_client/backend/backend.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/precept/binding/binding.dart';
import 'package:precept_client/precept/library/pageLibrary.dart';
import 'package:precept_client/precept/library/panelLibrary.dart';
import 'package:precept_client/precept/library/partLibrary.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/panel/panel.dart';
import 'package:precept_client/precept/part/pPart.dart';
import 'package:precept_client/precept/script/element.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:provider/provider.dart';

/// Creates companion Widgets according to the settings of [config]
/// See [User Guide](https://www.preceptblog.co.uk/user-guide/widget-tree.html)
/// [widget] is wrapped with companion widgets as appropriate for the [config] given.
/// [parentBinding] is not required for a [widget] that is using static data
mixin CommonBuilder {
  /// Wraps [widget] with a new [DataSource] and [DataBinding].  The [DataBinding] provides the root binding for all
  /// [Binding]  instances further down the tree.
  Widget addDataSource({@required Widget widget, @required PCommon config}) {
    if (config.dataSourceIsDeclared) {
      final dataSource = DataSource(config: config.dataSource);
      return ChangeNotifierProvider<DataSource>(
        create: (_) => dataSource,
        child: ChangeNotifierProvider<DataBinding>(
            create: (_) => DataBinding(binding: dataSource.rootBinding), child: widget),
      );
    }
    return widget;
  }

  Widget addBackend({@required Widget widget, @required PCommon config}) {
    return config.backendIsDeclared
        ? ChangeNotifierProvider<Backend>(
            create: (_) => Backend(config: config.backend), child: widget)
        : widget;
  }
}

/// Returns [widget] wrapped in [EditState] if [config.hasEditControl]
Widget addEditControl({@required Widget widget, @required PCommon config}) {
  return (config.hasEditControl)
      ? ChangeNotifierProvider<EditState>(create: (_) => EditState(), child: widget)
      : widget;
}

Widget addDataBinding(
    {@required BuildContext context,
    @required Widget widget,
    @required PCommon config,
    @required String property}) {
  return (config.isStatic == Triple.yes)
      ? widget
      : () {
          final parentBinding = Provider.of<DataBinding>(context, listen: false);
          widget = ChangeNotifierProvider<DataBinding>(
              create: (_) =>
                  DataBinding(binding: parentBinding.binding.modelBinding(property: property)),
              child: widget);
        };
}

Widget assembleContent(
    {@required BuildContext context, List<DisplayElement> content, bool scrollable}) {
  final List<Widget> children = List();
  for (var element in content) {
    Widget child;
    if (element is PPanel) {
      child = PanelBuilder().build(context: context, config: element);
    }
    if (element is PPart) {
      child =
          PartBuilder().build(context: context, callingType: element.runtimeType, config: element);
    }
    children.add(ChangeNotifierProvider<EditState>(create: (_) => EditState(), child: child));
  }
  return (scrollable) ? ListView(children: children) : Column(children: children);
}

class PartBuilder with CommonBuilder {
  /// Assembles the [Part] with appropriate [EditState] etc (see https://www.preceptblog.co.uk/user-guide/widget-tree.html)
  /// Throws a [PreceptException] on failure
  Widget build(
      {@required BuildContext context, @required Type callingType, @required PPart config}) {
    final part = partLibrary.find(callingType, config);
    Widget widget = part;
    widget = addEditControl(widget: widget, config: config);
    widget = addDataBinding(
      context: context,
      widget: widget,
      config: config,
      property: config.property,
    );
    widget = addDataSource(widget: widget, config: config);
    widget = addBackend(widget: widget, config: config);
    return widget;
  }
}

/// A 'page' is any stateless or stateful Widget you use to represent a 'page' to the user.
/// To work with Precept. the page must be [registered with the library](https://www.preceptblog.co.uk/user-guide/libraries.html#registering-with-a-library)
class PageBuilder with CommonBuilder {
  /// Assembles the page with [companion widgets](see https://www.preceptblog.co.uk/user-guide/widget-tree.html).
  /// Unless it is static, a page always creates a [Backend], [DataSource] and [DataBinding].
  /// This is because it is the first level of Widgets produces by the Precept build process, but may not be
  /// as efficient as it could be, see [open issue](https://gitlab.com/precept1/precept-client/-/issues/22)
  ///
  ///
  /// Throws a [PreceptException] on failure
  Widget build({@required PPage config}) {
    Widget widget = pageLibrary.find(config.pageType, config);
    widget=addEditControl(widget: widget, config: config);
    widget = addDataSource(widget: widget, config: config);
    widget = addBackend(widget: widget, config: config);
    return widget;
  }

  Widget buildContent({@required BuildContext context, @required PPage config}) {
    return assembleContent(
        context: context, content: config.content, scrollable: config.scrollable);
  }
}

class PanelBuilder with CommonBuilder {
  Widget build({@required BuildContext context, @required PPanel config}) {
    final panelWidget = panelLibrary.find(config.runtimeType, config);
    Widget widget = ChangeNotifierProvider<PanelState>(
        create: (_) => PanelState(config: config), child: panelWidget);
    widget = addEditControl(widget: widget, config: config);
    widget = addDataBinding(
      context: context,
      widget: widget,
      config: config,
      property: config.property,
    );
    widget = addDataSource(widget: widget, config: config);
    widget = addBackend(widget: widget, config: config);
    return widget;
  }

  Widget buildContent({@required BuildContext context, @required PPanel config}) {
    return assembleContent(
        context: context, content: config.content, scrollable: config.scrollable);
  }
}
