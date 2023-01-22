import 'dart:io';

import 'package:shelf_router/shelf_router.dart';

import 'package:call_and_response/call_and_response.dart';
import 'user.dart';

void main(List<String> args) async {
  final server = await (Router()
        ..addGet(
          '/app/<id>',
          (r, id) async => App(name: 'Bigapp', id: id),
          (u) => u.toJson(),
        ))
      .toServer(int.parse(Platform.environment['PORT']!));

  print('Server listening on port ${server.port}');
}
