// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      login: json['login'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'login': instance.login,
      'id': instance.id,
    };

App _$AppFromJson(Map<String, dynamic> json) => App(
      id: json['id'] as String?,
      name: json['name'] as String?,
      binary: json['binary'] as String?,
    );

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'binary': instance.binary,
    };
