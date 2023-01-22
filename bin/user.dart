// ignore_for_file: non_constant_identifier_names

//flutter pub run build_runner build --delete-conflicting-outputs

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({required this.id, required this.login});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  final String? login;
  final String? id;
}

@JsonSerializable()
class App {
  const App({required this.id, required this.name, this.binary});

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);

  Map<String, dynamic> toJson() => _$AppToJson(this);

  final String? name;
  final String? id;
  final String? binary;
}
