import 'package:example/fake_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

//This is a Widget test that spins up our fake server and then runs our app
//that makes actual HTTP calls to the server. This test does not work as a normal
//widget test because it uses the network. We need to run this as an integration
//test. Run the integration test version - not the widget test.

//I was hoping that we could pass an actual HttpClient into the test via HttpOverrides.runZoned
//But, it seems that if you pass an actual HttpClient in via createHttpClient
//It will just replace the client with a Mock anyway...

//This is in a sense reasonable because HTTP requires the underlying platform to work

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final fakeServerUrl = await fakeServer();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      baseUri: fakeServerUrl,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));

    //This is the only different with the standard Flutter Counter example test
    //This waits for the HTTP call to execute - i.e. waits for the spinner to stop spinning
    await tester.pumpAndSettle();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
