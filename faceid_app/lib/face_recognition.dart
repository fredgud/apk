import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class FaceRecognitionPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  FaceRecognitionPage({required this.cameras});

  @override
  _FaceRecognitionPageState createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends State<FaceRecognitionPage> {
  late CameraController controller;
  late Interpreter interpreter;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      startCameraStream();
    });

    loadModel();
  }

  void loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/modelo_faceid.tflite');
    print("✅ Modelo TFLite cargado");
  }

  void startCameraStream() {
    controller.startImageStream((CameraImage img) {
      // Aquí puedes preprocesar el frame y pasar a TFLite
      // Ejemplo: convertir a Float32List, redimensionar a 128x128
    });
  }

  @override
  void dispose() {
    controller.dispose();
    interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) return Container();
    return Scaffold(
      appBar: AppBar(title: Text("Face Recognition")),
      body: CameraPreview(controller),
    );
  }
}
