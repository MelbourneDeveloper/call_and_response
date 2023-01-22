import 'package:call_and_response/call_and_response.dart';
import 'package:shelf_router/shelf_router.dart' as router;

class CounterServerState {
  CounterServerState();
  int count = 0;
  Map<String, dynamic> toJson() => {"count": count};
  factory CounterServerState.fromJson(Map<String, dynamic> json) =>
      CounterServerState()..count = json["count"] as int;
}

///This state is private. It means the client app cannot access the state
///However, there is no reason we can't share state if we need to
///You can directly debug this code and log any calls to the server
CounterServerState _counter = CounterServerState();

///Spin up a HTTP server in the Flutter process that answers calls
Future<Uri> fakeServer() async {
  final server = await (router.Router()
        ..addGet(
          //TODO: Remove nothing
          '/count/<nothing>',
          (r, arg) async {
            _counter.count++;
            return _counter;
          },
          (state) => state.toJson(),
        ))
      .toServer(8088);

  return Uri.parse('http://${server.address.host}:${server.port}');
}
