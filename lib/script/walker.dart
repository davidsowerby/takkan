import '../validation/message.dart';
import 'takkan_element.dart';

/// Used to 'walk' a [TakkanElement] tree.  It is invoked at every entry within the tree, by calling
/// [TakkanElement.walk] at the highest level required. It simply returns the entry.
/// It is up to the implementation of this interface to decide what do with the entry.
abstract class ScriptVisitor {
  void step(Object entry);
}

abstract class WalkTarget {
  void walk(List<ScriptVisitor> visitors) {
    for (final ScriptVisitor visitor in visitors) {
      visitor.step(this);
    }
  }
}

abstract class WalkerParams {
  const WalkerParams();
}

abstract class Walker<PARAMS extends WalkerParams, TRACK> {
  final List<TRACK> tracker = List.empty(growable: true);

  void walk(TakkanElement root, PARAMS params) {
    final itemResult = _processItem(root, params);
    if (itemResult is List) {
      tracker.addAll(List<TRACK>.from(itemResult));
    } else {
      tracker.add(itemResult);
    }
    cascade(root, params);
  }

  TRACK _processItem(TakkanElement element, PARAMS params);

  void cascade(TakkanElement item, PARAMS params) {
    for (final Object child in item.subElements) {
      if (child is TakkanElement) {
        walk(child, childParams(item, params));
      } else {
        if (child is List) {
          final List<Object> c = List.castFrom(child);
          int count = 0;
          for (final Object entry in c) {
            if (entry is TakkanElement) {
              walk(entry, childParams(item, params, index: count));
            }
            count++;
          }
        } else {
          if (child is Map) {
            final Map<String, dynamic> c = Map.castFrom(child);
            for (final entry in c.entries) {
              if (entry.value is TakkanElement) {
                walk(entry.value as TakkanElement,
                    childParams(item, params, name: entry.key));
              }
            }
          }
        }
      }
    }
  }

  /// Override this if you need to modify the params as they are passed down the tree.
  /// See [InitWalker] for an example.
  PARAMS childParams(TakkanElement root, PARAMS params,
      {int? index, String? name}) {
    return params;
  }
}

class InitWalkerParams extends WalkerParams {
  const InitWalkerParams({this.name, this.index, this.useCaptionsAsIds = true});

  final int? index;
  final String? name;
  final bool useCaptionsAsIds;
}

class InitWalker extends Walker<InitWalkerParams, String> {
  @override
  String _processItem(TakkanElement element, InitWalkerParams params) {
    element.doInit(params);
    return element.debugId!;
  }

  @override
  InitWalkerParams childParams(TakkanElement root, InitWalkerParams params,
      {int? index, String? name}) {
    return InitWalkerParams(
      name: name,
      index: index,
      useCaptionsAsIds: params.useCaptionsAsIds,
    );
  }
}

class SetParentWalkerParams extends WalkerParams {
  const SetParentWalkerParams({
    required this.parent,
  });

  final TakkanElement parent;
}

class SetParentWalker extends Walker<SetParentWalkerParams, String> {
  @override
  String _processItem(TakkanElement element, SetParentWalkerParams params) {
    element.setParent(params);
    return element.runtimeType.toString();
  }

  @override
  SetParentWalkerParams childParams(TakkanElement root,
      SetParentWalkerParams params,
      {int? index, String? name}) {
    return SetParentWalkerParams(
      parent: root,
    );
  }
}

class VisitorWalker extends Walker<VisitorWalkerParams, String> {
  @override
  String _processItem(TakkanElement element, VisitorWalkerParams params) {
    for (final ScriptVisitor visitor in params.visitors) {
      visitor.step(element);
    }
    return element.debugId!;
  }
}

class ValidationWalker extends Walker<ValidationWalkerCollector, int> {
  @override
  int _processItem(TakkanElement element, ValidationWalkerCollector params) {
    element.doValidate(params);
    return params.messages.length;
  }
}

class ValidationWalkerCollector extends WalkerParams {
  final List<ValidationMessage> messages = [];
}

class EmptyWalkerParams extends WalkerParams {}

class VisitorWalkerParams extends WalkerParams {
  const VisitorWalkerParams({required this.visitors});

  final List<ScriptVisitor> visitors;
}

class SetDefaultsWalker extends Walker<EmptyWalkerParams, String> {
  @override
  String _processItem(TakkanElement element, EmptyWalkerParams params) {
    element.setDefaults();
    return element.runtimeType.toString();
  }
}
