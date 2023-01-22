import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

import '../bin/user.dart';

void main() {
  final port = '8080';
  final host = 'http://0.0.0.0:$port';
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  test('User', () async {
    final response = await get(Uri.parse('$host/user/jim'));
    expect(response.statusCode, 200);
    expect(response.body, jsonEncode(User(login: "jim", id: "123").toJson()));
  });

  test('App', () async {
    final response = await get(Uri.parse('$host/app/543'));
    expect(response.statusCode, 200);
    expect(response.body, jsonEncode(App(name: "Bigapp", id: "543").toJson()));
  });

  // test('App', () async {
  //   final response = await post(Uri.parse('$host/saveapp/543'), body: 'asd');
  //   expect(response.statusCode, 200);
  //   expect(response.body, jsonEncode(App(name: "Bigapp", id: "543").toJson()));
  // });

  test('404', () async {
    final response = await get(Uri.parse('$host/foobar'));
    expect(response.statusCode, 404);
  });
}
