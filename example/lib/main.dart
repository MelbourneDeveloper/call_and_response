import 'dart:convert';
import 'dart:io';
import 'package:example/fake_server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

Future main() async {
  Uri baseUri = await fakeServer();

  runApp(MyApp(baseUri: baseUri));
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.baseUri,
    super.key,
  });

  final Uri baseUri;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        baseUri: baseUri,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.baseUri,
  });

  final String title;
  final Uri baseUri;

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

            final response =
                await get(widget.baseUri.replace(pathSegments: ['count', '0']));

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
