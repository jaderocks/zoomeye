import 'dart:async';
import 'dart:io';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class FoodDetectionPage extends StatefulWidget {
  @override
  _FoodDetectionPageState createState() => _FoodDetectionPageState();
}

class _FoodDetectionPageState extends State<FoodDetectionPage> {
  late ARKitController arkitController;
  Timer? timer;
  bool anchorWasFound = false;
  static List<CameraDescription> _cameras = [];
  int _cameraIndex = -1;
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);
  bool _canProcess = true;
  bool _isBusy = false;
  String _text = '';
  String _recognizedText = '';

  @override
  void dispose() {
    timer?.cancel();
    arkitController.dispose();
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == CameraLensDirection.back) {
        _cameraIndex = i;
        break;
      }
    }
  }

  Future<InputImage> saveMemImageToInputImage(MemoryImage image, String fileName) async {
    Directory? dir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    final myImagePath = "${dir!.path}/$fileName"; 
    File imageFile = File(myImagePath); 
    if(!await imageFile.exists()){   
      imageFile.create(recursive: true); 
    } 

    print("Start to save image: ${myImagePath}");

    await imageFile.writeAsBytes(image.bytes);
  
    print("saved: ${myImagePath}");
    
    return InputImage.fromFilePath(myImagePath);
  }

  Future<InputImage> convertMemImageToInputImage(MemoryImage arImage) async {
    final img = await decodeImageFromList(arImage.bytes);

    return InputImage.fromBytes(
      bytes: arImage.bytes,
      metadata: InputImageMetadata(
        size: Size(img.width.toDouble(), img.height.toDouble()),
        rotation:
            InputImageRotation.rotation0deg, // used only in Android
        format: InputImageFormat.bgra8888, // used only in iOS
        bytesPerRow: img.width, // used only in iOS
      ),
    );
  }

  Future<void> processCurrentScene() async {
      if (!_canProcess) return;
      if (_isBusy) return;
      _isBusy = true;

      final arImage = (await arkitController.snapshot()) as MemoryImage;

      InputImage iImage = await saveMemImageToInputImage(arImage, "snapshot.jpg");

      final recognizedText = (await _textRecognizer.processImage(iImage)).text;
      
      if(_recognizedText != recognizedText) {
        _recognizedText = recognizedText;
        _text = 'Recognized text:\n\n$_recognizedText';
      }
 
      _isBusy = false;

      if (mounted) {
        setState(() {});
      }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Image Detection Sample')),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera),
          onPressed: () async {
            processCurrentScene();
          },
        ),
        body: Container(
          child: Stack(
            fit: StackFit.loose,
            children: [
              ARKitSceneView(
                detectionImagesGroupName: 'AR Resources',
                onARKitViewCreated: onARKitViewCreated,
              ),
              Container(
                width: MediaQuery.of(context).size.width, 
                height: 200.00,
                color: const Color.fromRGBO(255, 255, 255, 0.3),
                padding: const EdgeInsets.all(10.0),
                child: Text(_text),),
              anchorWasFound
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '请把摄像头指向食物说明书。',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      );

  // Future<void> _processImage(InputImage inputImage) async {
  //   if (!_canProcess) return;
  //   if (_isBusy) return;
  //   _isBusy = true;
  //   setState(() {
  //     _text = '';
  //   });
  //   final recognizedText = await _textRecognizer.processImage(inputImage);
  //   if (inputImage.metadata?.size != null &&
  //       inputImage.metadata?.rotation != null) {
  //     final painter = TextRecognizerPainter(
  //       recognizedText,
  //       inputImage.metadata!.size,
  //       inputImage.metadata!.rotation,
  //       _cameraLensDirection,
  //     );
  //     _customPaint = CustomPaint(painter: painter);
  //   } else {
  //     _text = 'Recognized text:\n\n${recognizedText.text}';
  //     // TODO: set _customPaint to draw boundingRect on top of image
  //     _customPaint = null;
  //   }
  //   _isBusy = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = onAnchorWasFound;
    this.arkitController.updateAtTime = (double time) => {
      processCurrentScene()
    };
  }

  void onAnchorWasFound(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor) {
      setState(() => anchorWasFound = true);

      final material = ARKitMaterial(
        lightingModelName: ARKitLightingModel.lambert,
        diffuse: ARKitMaterialProperty.image('earth.jpg'),
      );
      final sphere = ARKitSphere(
        materials: [material],
        radius: 0.1,
      );

      final earthPosition = anchor.transform.getColumn(3);
      final node = ARKitNode(
        geometry: sphere,
        position:
            vector.Vector3(earthPosition.x, earthPosition.y, earthPosition.z),
        eulerAngles: vector.Vector3.zero(),
      );
      arkitController.add(node);

      timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        final old = node.eulerAngles;
        final eulerAngles = vector.Vector3(old.x + 0.01, old.y, old.z);
        node.eulerAngles = eulerAngles;
      });
    }
  }
}
