import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomeye/examples/ar/body_tracking.dart';
import 'package:zoomeye/examples/ar/camera_position.dart';
import 'package:zoomeye/examples/ar/custom_animation.dart';
import 'package:zoomeye/examples/ar/custom_light.dart';
import 'package:zoomeye/examples/ar/custom_object_page.dart';
import 'package:zoomeye/examples/ar/distance_tracking_page.dart';
import 'package:zoomeye/examples/ar/earth_page.dart';
import 'package:zoomeye/examples/ar/face_detection_page.dart';
import 'package:zoomeye/examples/ar/hello.dart';
import 'package:zoomeye/examples/ar/image_detection_page.dart';
import 'package:zoomeye/examples/ar/light_estimate_page.dart';
import 'package:zoomeye/examples/ar/manipulation_page.dart';
import 'package:zoomeye/examples/ar/measure_page.dart';
import 'package:zoomeye/examples/ar/midas_page.dart';
import 'package:zoomeye/examples/ar/network_image_detection.dart';
import 'package:zoomeye/examples/ar/occlusion_page.dart';
import 'package:zoomeye/examples/ar/panorama_page.dart';
import 'package:zoomeye/examples/ar/physics_page.dart';
import 'package:zoomeye/examples/ar/plane_detection_page.dart';
import 'package:zoomeye/examples/ar/real_time_updates.dart';
import 'package:zoomeye/examples/ar/snapshot_scene.dart';
import 'package:zoomeye/examples/ar/tap_page.dart';
import 'package:zoomeye/examples/ar/video_page.dart';
import 'package:zoomeye/examples/ar/widget_projection.dart';
import 'package:zoomeye/examples/ar/world.dart';
import 'package:zoomeye/examples/detector/object_detector.dart';
import 'package:zoomeye/examples/detector/text_detector.dart';
import 'package:zoomeye/examples/nlp/language_identifier_view.dart';
import 'package:zoomeye/examples/nlp/language_translator.dart';
import 'package:zoomeye/screen/food.dart';

void main() {
  // runApp(const MyApp());
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String _platformVersion = 'Unknown';
  static const String _title = 'AR Plugin Demo';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = Platform.version;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text(_title),
          ),
          body: Column(children: [
            Text('Running on: $_platformVersion\n'),
            const Expanded(
              child: ExampleList(),
            ),
          ]),
        ),
      );
    }
  }

class ExampleList extends StatelessWidget {
  const ExampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final examples = [
      Example(
          'Food Detector',
          'Detector Food in the camera',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => FoodDetectionPage()))),
      Example(
          '[D] Object Detector',
          'Detector Object in the camera',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ObjectDetectorView()))),
      Example(
          '[D] Text Detector',
          'Detector Text in the camera',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => TextRecognizerView()))),
      Example(
          '[NLP] Language Identifier',
          'Langeauge Indentifier in the camera',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LanguageIdentifierView()))),
      Example(
          '[NLP] Language Translator',
          'Language Translator in the camera',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LanguageTranslatorView()))),
      Example(
          '[NLP] Entity Extractor',
          'Entity Extractor in the camera',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LanguageTranslatorView()))),
      Example(
          '[NLP] Smart reply',
          'Smart Reply in the camera',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LanguageTranslatorView()))),
      Example(
          'Hello',
          'Visualize Ball',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => HelloWidget()))),
      Example(
          'Hello World',
          'Visualize basich shapes',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => HelloWorldPage()))),
      Example(
          'Check support',
          'Check the device is support AR or Not',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => HelloWorldPage()))),
      Example(
          'Camera Position',
          'Live Carmera Position',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CameraPositionScenePage()))),
      Example(
          'Custom Animation',
          'Animation',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomAnimationPage()))),
      Example(
          'Custom Light',
          'Light',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomLightPage()))),
      Example(
          'Custom Object',
          'Object',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomObjectPage()))),
      Example(
          'Distance Tracking',
          'Distance',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => DistanceTrackingPage()))),
      Example(
          'Earth',
          'Earth',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => EarthPage()))),
      Example(
          'Face',
          'Face Detection',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => FaceDetectionPage()))),
      Example(
          'Image',
          'Image Detection',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ImageDetectionPage()))),
      Example(
          'Light',
          'Light Estimate',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LightEstimatePage()))),
      Example(
          'Manipulation',
          'Manipulation Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManipulationPage()))),
      Example(
          'Measure',
          'Measure Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => MeasurePage()))),
      Example(
          'Media',
          'Media Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => MidasPage()))),
      Example(
          'Network',
          'Network Image Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => NetworkImageDetectionPage()))),
      Example(
          'Occlusion',
          'Occlusion Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => OcclusionPage()))),
      Example(
          'Panorama',
          'Panorama Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PanoramaPage()))),
      Example(
          'Physiscs',
          'Physiscs Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PhysicsPage()))),
      Example(
          'Plane Detection',
          'Plane Detection Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PlaneDetectionPage()))),
      Example(
          'Real Time Updates',
          'Real Time Updates Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => RealTimeUpdatesPage()))),
      Example(
          'Snapshot scene',
          'Snapshot scene Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => SnapshotScenePage()))),
      Example(
          'Tap ',
          'Tap Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => TapPage()))),
      Example(
          'Video ',
          'Video Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => VideoPage()))),
      Example(
          'Widget ',
          'Widget Projection Page',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => WidgetProjectionPage()))),
      Example(
          'Body Tracking',
          'Visualize Body Tracking',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => BodyTrackingPage())))
    ];
    return ListView(
      children:
          examples.map((example) => ExampleCard(example: example)).toList(),
    );
  }
}

class ExampleCard extends StatelessWidget {
  const ExampleCard({Key? key, required this.example}) : super(key: key);
  final Example example;

  @override
  build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          example.onTap();
        },
        child: ListTile(
          title: Text(example.name),
          subtitle: Text(example.description),
        ),
      ),
    );
  }
}

class Example {
  const Example(this.name, this.description, this.onTap);
  final String name;
  final String description;
  final Function onTap;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
