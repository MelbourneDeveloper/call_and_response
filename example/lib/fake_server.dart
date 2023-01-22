import 'package:call_and_response/call_and_response.dart';
import 'package:shelf_router/shelf_router.dart' as router;

class CounterServerState {
  CounterServerState();
  int count = 0;
  Map<String, dynamic> toJson() => {"count": count};
  factory CounterServerState.fromJson(Map<String, dynamic> json) =>
      CounterServerState()..count = json["count"] as int;
}

///Spin up a HTTP server in the Flutter process that answers calls
Future<Uri> fakeServer() async {
  //This state is local to this function. It means
  CounterServerState counter = CounterServerState();

  final server = await (router.Router()
        ..addGet(
          //TODO: Remove nothing
          '/count/<nothing>',
          (r, arg) async {
            counter.count++;
            return counter;
          },
          (state) => state.toJson(),
        ))
      .toServer(8087);

  return Uri.parse('http://${server.address.host}:${server.port}');
}
