import 'dart:io';

import 'package:shelf_router/shelf_router.dart';

import 'fake_server.dart';
import 'user.dart';

void main(List<String> args) async {
  final server = await (Router()
        ..addGet(
          '/app/<id>',
          (r, id) => App(name: 'Bigapp', id: id),
          (u) => u.toJson(),
        ))
      .toServer(int.parse(Platform.environment['PORT']!));

  print('Server listening on port ${server.port}');
}