import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../util/walker.dart';
import 'document.dart';

part 'permissions.g.dart';

/// The design of [Permissions] was influenced principally by Back4App, but with
/// one key difference.  A Back4App Class (the equivalent of a Takkan [Document])
/// is public by default.  A Takkan [Document] however, is private by default.
///
/// Access control is by giving permissions, not by adding restrictions,
///
/// The default settings create a fully private [Document] which no-one can
/// access.
///
/// Starting from that fully private setting, you can add role names
/// to those methods you want to give access to.
///
/// The following examples relate to [AccessMethod.create] but are applicable to
/// any of the basic access methods (see [AccessMethodExtension.basicMethods]).
///
///  - to specify that at 'editor' or 'author' role can create a document,
///  include an entry  { [AccessMethod.create]: ['editor', 'author'] }
///
///  - to specify that a user only requires authentication to create a document,
///  include an entry  { [AccessMethod.create]: [authOnly] }
///
/// - to specify that absolutely anyone can create a document, include an entry
///  { [AccessMethod.create]: [publicAccess] }
///
/// Bear in mind that the most open permission will override others, so for example:
///
///  - { [AccessMethod.create]: ['editor', 'author', authOnly] }
///
///  effectively ignores the roles and grants access to any authenticated user.
///  The same principle applies to granting [publicAccess] access.
///
/// There are some 'group' methods - that is, those which are not
/// [AccessMethodExtension.basicMethods].  These are just to simplify specification
/// and play no part beyond that.  For example, with [AccessMethod.all] you could
/// specify:
///
///  - { [AccessMethod.all]: ['admin'] }
///
///  to grant admin access to all methods.
///
/// See also [AccessMethod.read] and [AccessMethod.write]
@JsonSerializable(explicitToJson: true)
class Permissions extends Equatable with WalkTarget {

  Permissions({Map<AccessMethod, List<String>> permissions = const {}})
      : _permissions = Permissions.expandSpec(permissions);
  /// Use only with a set of already expanded (see [expandSpec]])  permissions.
  /// That means it should contain only the [AccessMethod.basicMethods], and is
  /// why the constructor is private.
  /// [PermissionsDiff.applyTo]
  Permissions._fromExpandedSet(
      {required Map<AccessMethod, Set<String>> permissions})
      : _permissions = permissions;

  factory Permissions.fromJson(Map<String, dynamic> json) =>
      _$PermissionsFromJson(json);

  final Map<AccessMethod, Set<String>> _permissions;

  Map<AccessMethod, Set<String>> get permissions => Map.from(_permissions);

  /// Returns all the roles defined for all methods
  Set<String> get allRoles => _permissions.values.expand((v) => v).toSet();

  Map<String, dynamic> toJson() => _$PermissionsToJson(this);

  /// This method only supports basic methods, see [AccessMethodExtension.isBasicMethod]
  ///
  /// Calling with any other [AccessMethod]
  ///
  /// Permissions are given from a starting point of not having any, so if no
  /// permissions have been given this method returns true, even though it seems
  /// pointless to require authentication when the user still will not gain access.
  /// However, if it returned false, we would be making access public.
  ///
  /// The only time this method returns false is when a method is declared
  /// [publicAccess].
  bool requiresAuthentication(AccessMethod method) {
    if (method.isNotBasicMethod) {
      throw UnsupportedError(
          'This method requires one of the basic methods, see AccessMethodExtension.isBasicMethod');
    }
    final perms = _permissions[method];
    if (perms == null) {
      return true;
    }
    return !perms.contains(publicAccess);
  }

  /// Returns only the roles for [method].  [publicAccess] and [authOnly] are
  /// not included
  Set<String> roles(AccessMethod method) {
    if (method.isNotBasicMethod) {
      throw UnsupportedError(
          'This method requires one of the basic methods, see AccessMethodExtension.isBasicMethod');
    }
    final perms = _permissions[method];
    if (perms == null) {
      return {};
    }
    perms.remove(publicAccess);
    perms.remove(authOnly);
    perms.toSet();
    return perms;
  }

  bool isPublic(AccessMethod method) {
    return !requiresAuthentication(method);
  }

  /// Returns true if a user has permission to access [method], given whether
  /// that [userIsAuthenticated] and the [userRoles] they have.
  ///
  /// This call only supports basic access methods, see [AccessMethodExtension.isBasicMethod]
  bool hasPermission(
      AccessMethod method, bool userIsAuthenticated, Set<String> userRoles) {
    if (method.isNotBasicMethod) {
      throw UnsupportedError(
          'This method requires one of the basic methods, see AccessMethodExtension.isBasicMethod');
    }
    if (isPublic(method)) {
      return true;
    }
    // Method is not public so must at least require authentication
    if (!userIsAuthenticated) {
      return false;
    }

    final perms = _permissions[method];
    // User is authenticated, so if permissions include authOnly, we can give permission
    if (perms == null) {
      return false;
    }
    if (perms.contains(authOnly)){
      return true;
    }

    // Now we can give permission if perms contain any of the user's roles
    final bool hasPermission =
        perms.any((permission) => userRoles.contains(permission));
    return hasPermission;
  }

  @override
  List<Object?> get props => [
        _permissions,
      ];

  /// Takes the [spec] provided to the constructor, which may contain entries
  /// for [AccessMethod.all],[AccessMethod.read] or [AccessMethod.write].
  /// The expanded result contains entries only for the basicMethods as defined
  /// by [AccessMethodExtension.basicMethods]
  static Map<AccessMethod, Set<String>> expandSpec(
      Map<AccessMethod, List<String>> spec) {
    final Map<AccessMethod, Set<String>> mapping = {};
    spec.forEach((specKey, specValue) {
      final Set<AccessMethod> members = specKey.groupMembers;
      for (final member in members) {
        final currentContent = mapping.putIfAbsent(member, () => HashSet());
        currentContent.addAll(specValue.toSet());
      }
    });

    return mapping;
  }
}

@JsonSerializable(explicitToJson: true)
class PermissionsDiff {
  const PermissionsDiff({this.addRoles, this.removeRoles});

  factory PermissionsDiff.fromJson(Map<String, dynamic> json) =>
      _$PermissionsDiffFromJson(json);
  final Map<AccessMethod, List<String>>? addRoles;
  final Map<AccessMethod, List<String>>? removeRoles;

  Permissions applyTo(Permissions permissions) {
    // This is a copy as permissions.permissions uses Map.from
    final copy = permissions.permissions;
    if (addRoles != null) {
      final toAdd = Permissions.expandSpec(addRoles!);
      // merge new permissions with original
      toAdd.forEach((key, value) {
        final existing = copy[key] ?? HashSet();
        existing.addAll(value);
        copy[key]= existing;
      });
    }
    if (removeRoles != null) {
      final toRemove = Permissions.expandSpec(removeRoles!);
      toRemove.forEach((key, value) {
        final existing = copy[key];
        if (existing != null) {
          existing.removeAll(value);
        }
      });
    }
    return Permissions._fromExpandedSet(permissions: copy);
  }

  Map<String, dynamic> toJson() => _$PermissionsDiffToJson(this);
}

const String publicAccess = '--public field--';
const String authOnly = '--authenticate only--';
