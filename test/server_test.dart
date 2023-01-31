import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:test/test.dart';

import '../lib/call_and_response.dart';
import '../bin/user.dart';

void main() {
  test('GET - In Process - User', () async {
    final server = await (Router()
          ..addGet(
            '/user/<login>',
            (r, arg) async => User(login: arg, id: "123"),
            (u) => u.toJson(),
          ))
        .toServer(8083);

    final response = await get(
        Uri.parse('http://${server.address.host}:${server.port}/user/jim'));

    expect(response.statusCode, 200);
    expect(response.body, jsonEncode(User(login: "jim", id: "123").toJson()));

    await server.close(force: true);
  });

  test('GET - Out of Test Process - App', () async {
    final port = '8085';
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

  test('GET - In Process - 404', () async {
    final server = await Router().toServer(8081);
    var uri = 'http://${server.address.host}:${server.port}/foobar';
    final response = await get(Uri.parse(uri));
    expect(response.statusCode, 404);
    await server.close(force: true);
  });

  test('POST - In Process - User', () async {
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

  test('PUT - In Process - User', () async {
    final Map<String, dynamic> responseBody = {'message': 'success'};

    final server = await (Router()
          ..addPut(
            '/updateuser/<login>',
            (r, arg) async => true,
            (success) => success ? responseBody : {},
          ))
        .toServer(8083);

    final response = await put(
        Uri.parse(
            'http://${server.address.host}:${server.port}/updateuser/jim'),
        body: User(login: 'jim', id: "123").toJson());

    expect(response.statusCode, 200);
    expect(response.body, jsonEncode(responseBody));

    await server.close(force: true);
  });

  test('DELETE - In Process', () async {
    final Map<String, dynamic> responseBody = {'message': 'success'};

    final server = await (Router()
          ..addDelete(
            '/updateuser/<login>',
            (r, arg) async => arg == 'jim',
            (success) => success ? responseBody : {},
          ))
        .toServer(8083);

    final response = await delete(
        Uri.parse(
            'http://${server.address.host}:${server.port}/updateuser/jim'),
        body: User(login: 'jim', id: "123").toJson());

    expect(response.statusCode, 200);
    expect(response.body, jsonEncode(responseBody));

    await server.close(force: true);
  });

  test('HEAD - In Process', () async {
    final Map<String, dynamic> responseBody = {'message': 'success'};

    final server = await (Router()
          ..addHead(
            '/head/<login>',
          ))
        .toServer(8083);

    final response = await head(
      Uri.parse('http://${server.address.host}:${server.port}/head/21'),
    );

    expect(response.statusCode, 200);
    expect(response.body, '');

    await server.close(force: true);
  });
}
