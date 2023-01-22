import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shelf_router/shelf_router.dart' as router;
import 'package:http/http.dart';
import 'package:call_and_response/call_and_response.dart';

class CounterServerState {
  CounterServerState();
  int count = 0;
  Map<String, dynamic> toJson() => {"count": count};
  factory CounterServerState.fromJson(Map<String, dynamic> json) =>
      CounterServerState()..count = json["count"] as int;
}

late final HttpServer server;
CounterServerState counter = CounterServerState();

Future main() async {
  server = await (router.Router()
        ..addGet(
          //TODO: Remove nothing
          '/count/<nothing>',
          (r, arg) async {
            counter.count++;
            return counter;
          },
          (state) => state.toJson(),
        ))
      .toServer(8086);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final client = HttpClient();

  int? count = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have called the API this many times:',
              ),
              count == null
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      count!.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              count = null;
            });

            final response = await get(Uri.parse(
                'http://${server.address.host}:${server.port}/count/0'));

            final state =
                CounterServerState.fromJson(jsonDecode(response.body));

            setState(() {
              count = state.count;
            });
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
