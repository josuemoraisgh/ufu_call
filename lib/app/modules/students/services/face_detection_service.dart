import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/vector.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:ufu_call/app/utils/faces/camera_controle_service.dart';

import '../../../utils/faces/image_converter.dart';
import '../models/stream_students_model.dart';

const tfLiteGpuInferenceUsage = {
  'TFLITE_GPU_INFERENCE_PREFERENCE_FAST_SINGLE_ANSWER': 0,
  'TFLITE_GPU_INFERENCE_PREFERENCE_SUSTAINED_SPEED': 1,
  'TFLITE_GPU_INFERENCE_PREFERENCE_BALANCED': 2,
};

const tfLiteGpuInferencePriority = {
  'TFLITE_GPU_INFERENCE_PRIORITY_AUTO': 0,
  'TFLITE_GPU_INFERENCE_PRIORITY_MAX_PRECISION': 1,
  'TFLITE_GPU_INFERENCE_PRIORITY_MIN_LATENCY': 2,
  'TFLITE_GPU_INFERENCE_PRIORITY_MIN_MEMORY_USAGE': 3,
};

const tfLiteGpuExperimentalFlags = {
  'TFLITE_GPU_EXPERIMENTAL_FLAGS_NONE': 0,
  'TFLITE_GPU_EXPERIMENTAL_FLAGS_ENABLE_QUANT': 1 << 0,
  'TFLITE_GPU_EXPERIMENTAL_FLAGS_CL_ONLY': 1 << 1,
  'TFLITE_GPU_EXPERIMENTAL_FLAGS_GL_ONLY': 1 << 2,
  'TFLITE_GPU_EXPERIMENTAL_FLAGS_ENABLE_SERIALIZATION': 1 << 3,
};

const tFLGpuDelegateWaitType = {
  'TFLGpuDelegateWaitTypePassive': 0,
  'TFLGpuDelegateWaitTypeActive': 1,
  'TFLGpuDelegateWaitTypeDoNotWait': 2,
  'TFLGpuDelegateWaitTypeAggressive': 3,
};

class FaceDetectionService extends Disposable {
  late Interpreter interpreter;
  //late IsolateInterpreter isolateInterpreter;
  late final FaceDetector faceDetector;
  //late SensorOrientationDetector orientation;
  final threshold = RxNotifier<double>(1.5);

  static const pontosdoModelo = 192; //512
  static const nomedoInterpreter =
      'assets/mobilefacenet2.tflite'; //'assets/mobilefacenet3.tflite'

  var faceCompleter = Completer<bool>();

  FaceDetectionService({FaceDetector? faceDetector}) {
    this.faceDetector = faceDetector ?? Modular.get<FaceDetector>();
    init();
  }

  Future<void> init() async {
    if (!faceCompleter.isCompleted) {
      faceCompleter.complete(await initializeInterpreter());
    }
    //interpreter.allocateTensors();
    //orientation = SensorOrientationDetector();
    //await orientation.init();
  }

  Future<bool> initializeInterpreter() async {
    Delegate? delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
            options: GpuDelegateOptionsV2(
          isPrecisionLossAllowed: false,
          inferencePreference: tfLiteGpuInferenceUsage[
              'TFLITE_GPU_INFERENCE_PREFERENCE_FAST_SINGLE_ANSWER']!,
          inferencePriority1: tfLiteGpuInferencePriority[
              'TFLITE_GPU_INFERENCE_PRIORITY_MIN_LATENCY']!,
          inferencePriority2:
              tfLiteGpuInferencePriority['TFLITE_GPU_INFERENCE_PRIORITY_AUTO']!,
          inferencePriority3:
              tfLiteGpuInferencePriority['TFLITE_GPU_INFERENCE_PRIORITY_AUTO']!,
        ));
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
              allowPrecisionLoss: true,
              waitType:
                  tFLGpuDelegateWaitType['TFLGpuDelegateWaitTypeActive']!),
        );
      } else if (Platform.isWindows) {}
      InterpreterOptions interpreterOptions = InterpreterOptions()
        ..addDelegate(delegate!);

      interpreter = await Interpreter.fromAsset(nomedoInterpreter,
          options: interpreterOptions);
      //isolateInterpreter = await IsolateInterpreter.create(address: interpreter.address);
    } catch (e) {
      debugPrint('Filed to load model.');
      debugPrint(e.toString());
    }
    return true;
  }

  Future<void> predict(
      CameraImage cameraImage,
      CameraService cameraService,
      List<StreamStudents> assistidos,
      RxNotifier<List<StreamStudents>> assistidoProvavel) async {
    await faceCompleter.future;
    List<StreamStudents> assistidosIdentList = [];
    List<List> inputs = [];
    double min = 2.0;
    Map<int, List<List<double>>> outputs = {};
    int i = 0, j = 0, k = 0;
    imglib.Image? image =
        imgLibImageFromCameraImage(cameraImage, cameraService);
    InputImage? inputImage =
        inputImageFromCameraImage(cameraImage, cameraService);
    if (image != null && inputImage != null) {
      final List<Face> facesDetected =
          await faceDetector.processImage(inputImage);
      if (facesDetected.isNotEmpty) {
        k = 0;
        for (var faceDetected in facesDetected) {
          outputs.addAll({
            k++: [List.filled(pontosdoModelo, 0)]
          });
          var imageAux = cropFace(image, faceDetected, step: 80) ?? image;
          inputs.add([_preProcessImage(imageAux)]);
        }
        interpreter.runForMultipleInputs(inputs, outputs);
        for (i = 0; i < assistidos.length; i++) {
          for (j = 0; j < outputs.length; j++) {
            if (assistidos[i].fotoPoints!.isNotEmpty) {
              var vector1 = Vector.fromList(assistidos[i].fotoPoints!);
              final vectorOut = Vector.fromList(outputs[0]![j]);
              final n2 = vectorOut.norm();
              final aux = vector1.distanceTo(vectorOut / n2,
                  distance: Distance.euclidean);
              //debugPrint(aux.toString());
              if (aux <= threshold.value) {
                if (aux < min) {
                  min = aux;
                  assistidosIdentList = [assistidos[i]] + assistidosIdentList;
                } else {
                  assistidosIdentList.add(assistidos[i]);
                }
              }
            }
          }
        }
      }
    }
    assistidoProvavel.value = assistidosIdentList;
  }

  Future<List<double>> classificatorImage(imglib.Image image) async {
    await faceCompleter.future;
    List<List<double>> output =
        List.generate(1, (index) => List.filled(pontosdoModelo, 0));
    List input = [_preProcessImage(image)];
    interpreter.run(input, output);
    final n2 = Vector.fromList(output[0]).norm();
    final resp = output[0].map((e) => e / n2).toList();
    return resp;
  }

  Float32List preProcessImage1(imglib.Image image, Face faceDetected) {
    imglib.Image? croppedImage = cropFace(image, faceDetected);
    if (croppedImage != null) {
      imglib.copyResize(image, width: 120);
      imglib.Image imageResized = imglib.copyResizeCropSquare(croppedImage,
          size: 112, interpolation: imglib.Interpolation.linear);
      //final uint8List = Uint8List.fromList(imglib.encodeJpg(imageResized));
      //final img2 = imglib.decodeJpg(uint8List);
      //if (img2 != null) {
      Float32List imageAsList = float32ListFromImgLibImage(imageResized);
      return imageAsList;
      //}
    }
    return [] as Float32List;
  }

  List _preProcessImage(imglib.Image img,
      {int newWidth = 112, int newHeight = 112}) {
    Vector a, b, c, d;
    int yi, xi, x1, x2, y1, y2;
    double x,
        y,
        dx,
        dy,
        xOrigCenter,
        yOrigCenter,
        xScaledCenter,
        yScaledCenter,
        scaleX,
        scaleY;

    List newImage = List.generate(
        newHeight, (index) => List.filled(newWidth, [0.0, 0.0, 0.0]));

    final int origHeight = img.height, origWidth = img.width;
    List originalImg =
        img.data?.getBytes().toList().reshape([origHeight, origWidth, 3]) ?? [];
    if (originalImg.isNotEmpty) {
      // Compute center column and center row
      xOrigCenter = (origWidth - 1) / 2;
      yOrigCenter = (origHeight - 1) / 2;

      // Compute center of resized image
      xScaledCenter = (newWidth - 1) / 2;
      yScaledCenter = (newHeight - 1) / 2;

      // Compute the scale in both axes
      scaleX = origWidth / newWidth;
      scaleY = origHeight / newHeight;

      for (yi = 0; yi < newHeight; yi++) {
        for (xi = 0; xi < newWidth; xi++) {
          x = (xi - xScaledCenter) * scaleX + xOrigCenter;
          y = (yi - yScaledCenter) * scaleY + yOrigCenter;

          x1 = max<int>(min<int>(x.floor(), origWidth - 1), 0);
          y1 = max<int>(min<int>(y.floor(), origHeight - 1), 0);
          x2 = max<int>(min<int>(x.ceil(), origWidth - 1), 0);
          y2 = max<int>(min<int>(y.ceil(), origHeight - 1), 0);

          a = Vector.fromList(originalImg[y1][x1].cast<int>());
          b = Vector.fromList(originalImg[y2][x1].cast<int>());
          c = Vector.fromList(originalImg[y1][x2].cast<int>());
          d = Vector.fromList(originalImg[y2][x2].cast<int>());

          dx = x - x1;
          dy = y - y1;

          newImage[yi][xi] = ((a * (1 - dx) * (1 - dy) +
                      b * dy * (1 - dx) +
                      c * dx * (1 - dy) +
                      d * dx * dy) /
                  255)
              .toList();
        }
      }
    }
    return newImage;
  }

  @override
  void dispose() {
    interpreter.close();
    faceDetector.close();
  }
}
