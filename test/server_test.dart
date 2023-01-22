import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:test/test.dart';

import '../bin/fake_server.dart';
import '../bin/user.dart';

void main() {
  test('Test GET User In Test Process', () async {
    final server = await (Router()
          ..addGet(
            '/user/<login>',
            (r, arg) => User(login: arg, id: "123"),
            (u) => u.toJson(),
          ))
        .toServer(8083);

    final response = await get(
        Uri.parse('http://${server.address.host}:${server.port}/user/jim'));
    expect(response.statusCode, 200);
    expect(response.body, jsonEncode(User(login: "jim", id: "123").toJson()));
    await server.close(force: true);
  });

  test('Test GET App Out of Test Process', () async {
    final port = '8080';
    final host = 'http://0.0.0.0:$port';
    late Process p;

    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;

    final response = await get(Uri.parse('$host/app/543'));
    expect(response.statusCode, 200);
    expect(response.body, jsonEncode(App(name: "Bigapp", id: "543").toJson()));
    p.kill();
  });

  test('Test 404 In Process', () async {
    final server = await Router().toServer(8081);
    var uri = 'http://${server.address.host}:${server.port}/foobar';
    final response = await get(Uri.parse(uri));
    expect(response.statusCode, 404);
    await server.close(force: true);
  });

  test('Test POST User In Process', () async {
    var user = User(login: 'bob', id: "123");
    final server = await (Router()
          ..addPost(
            '/adduser/<login>',
            (r, arg) async {
              return user;
            },
            (u) => u.toJson(),
          ))
        .toServer(8082);

    final response = await post(
        Uri.parse('http://${server.address.host}:${server.port}/adduser/jim'),
        body: user.toJson());
    expect(response.statusCode, 200);
    expect(response.body, jsonEncode(user.toJson()));
    await server.close(force: true);
  });
}
