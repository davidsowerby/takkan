// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permissions _$PermissionsFromJson(Map<String, dynamic> json) => Permissions(
      permissions: (json['permissions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry($enumDecode(_$AccessMethodEnumMap, k),
                (e as List<dynamic>).map((e) => e as String).toList()),
          ) ??
          const {},
    );

Map<String, dynamic> _$PermissionsToJson(Permissions instance) =>
    <String, dynamic>{
      'permissions': instance.permissions
          .map((k, e) => MapEntry(_$AccessMethodEnumMap[k]!, e.toList())),
    };

const _$AccessMethodEnumMap = {
  AccessMethod.all: 'all',
  AccessMethod.read: 'read',
  AccessMethod.get: 'get',
  AccessMethod.find: 'find',
  AccessMethod.count: 'count',
  AccessMethod.write: 'write',
  AccessMethod.create: 'create',
  AccessMethod.update: 'update',
  AccessMethod.delete: 'delete',
  AccessMethod.addField: 'addField',
};

PermissionsDiff _$PermissionsDiffFromJson(Map<String, dynamic> json) =>
    PermissionsDiff(
      addRoles: (json['addRoles'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$AccessMethodEnumMap, k),
            (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      removeRoles: (json['removeRoles'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$AccessMethodEnumMap, k),
            (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$PermissionsDiffToJson(PermissionsDiff instance) =>
    <String, dynamic>{
      'addRoles': instance.addRoles
          ?.map((k, e) => MapEntry(_$AccessMethodEnumMap[k]!, e)),
      'removeRoles': instance.removeRoles
          ?.map((k, e) => MapEntry(_$AccessMethodEnumMap[k]!, e)),
    };
