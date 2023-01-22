import 'package:shelf_router/shelf_router.dart';

import 'fake_server.dart';
import 'user.dart';

void main(List<String> args) async {
  final server = await (Router()
        ..addGet(
          '/user/<login>',
          (r, arg) => User(login: arg, id: "123"),
          (u) => u.toJson(),
        )
        ..addGet(
          '/app/<id>',
          (r, id) => App(name: 'Bigapp', id: id),
          (u) => u.toJson(),
        ))
      .toServer();

  print('Server listening on port ${server.port}');
}
