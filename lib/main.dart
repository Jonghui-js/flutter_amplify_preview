import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  // Instantiate Amplify
  Amplify amplifyInstance = Amplify();

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (!mounted) return;

    // Add Pinpoint and Cognito Plugins
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    // AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyStorageS3 storage = AmplifyStorageS3();
    amplifyInstance.addPlugin(
        //  authPlugins: [authPlugin],
        storagePlugins: [storage], analyticsPlugins: [analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    await amplifyInstance.configure(amplifyconfig);
    try {
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

// Send an event to Pinpoint
  void _recordEvent() async {
    AnalyticsEvent event = AnalyticsEvent("test");
    event.properties.addBoolProperty("boolKey", true);
    event.properties.addDoubleProperty("doubleKey", 10.0);
    event.properties.addIntProperty("intKey", 10);
    event.properties.addStringProperty("stringKey", "stringValue");
    Amplify.Analytics.recordEvent(event: event);
  }

  void _redButtonEvent() async {
    AnalyticsEvent event = AnalyticsEvent("actionbutton");
    event.properties.addBoolProperty("boolKey", true);
    event.properties.addDoubleProperty("doubleKey", 10.0);
    event.properties.addIntProperty("intKey", 10);
    event.properties.addStringProperty("stringKey", "stringValue");
    print(event.name);
    await Amplify.Analytics.recordEvent(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'DoHyeon'),
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(Icons.star),
              onPressed: () {
                _redButtonEvent();
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              title: const Text('Amplify For Flutter'),
            ),
            body: ListView(padding: EdgeInsets.all(10.0), children: <Widget>[
              Center(
                child: Column(children: [
                  const Padding(padding: EdgeInsets.all(5.0)),
                  Text(_amplifyConfigured ? "configured" : "not configured"),
                  RaisedButton(
                      onPressed: _amplifyConfigured ? _recordEvent : null,
                      child: const Text('record event'))
                ]),
              )
            ])));
  }
}
