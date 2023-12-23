import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../../utils/faces/camera_controle_service.dart';
import '../../../utils/faces/camera_preview_with_paint.dart';
import '../../../utils/faces/image_converter.dart';
import '../services/face_detection_service.dart';
import '../../../utils/faces/painters/face_detector_painter.dart';
import '../students_controller.dart';
import '../models/stream_students_model.dart';
import 'package:image/image.dart' as imglib;

class StudentsFaceDetectorView extends StatefulWidget {
  final RxNotifier<List<StreamStudents>>? studentsProvavel;
  final List<StreamStudents>? studentsList;
  final StackFit? stackFit;
  const StudentsFaceDetectorView(
      {super.key, this.studentsList, this.studentsProvavel, this.stackFit});

  @override
  State<StudentsFaceDetectorView> createState() =>
      _StudentsFaceDetectorViewState();
}

class _StudentsFaceDetectorViewState extends State<StudentsFaceDetectorView> {
  late Future<bool> isInited;
  late final FaceDetectionService faceDetectionService;

  bool _canProcess = true, _isBusy = false, _isFace = false;
  CameraService? _cameraService = Modular.get<CameraService>();
  CameraImage? cameraImage;
  List<Face>? faces;

  CustomPaint? _customPaint;

  Future<bool> init() async {
    faceDetectionService =
        Modular.get<StudentsController>().faceDetectionService;
    _cameraService = _cameraService ?? CameraService();
    return true;
  }

  @override
  void initState() {
    isInited = init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isInited,
      builder: (BuildContext context, AsyncSnapshot<bool> initCameras) {
        if (initCameras.data != null) {
          return CameraPreviewWithPaint(
            cameraService: _cameraService,
            customPaint: _customPaint,
            onPaintLiveImageFunc: _processImage,
            takeImageFunc: _cameraTakeImage,
            isRealTime: widget.studentsList != null,
            stackFit: widget.stackFit,
            initialDirection: CameraLensDirection.back,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _cameraTakeImage(Uint8List? uint8ListImage) async {
    if (widget.studentsList != null) {
      if ((faces?.isNotEmpty ?? false) &&
          (cameraImage != null) &&
          (_cameraService?.camera != null)) {
        if (faces!.length > 1) {
          debugPrint("duas faces");
        }
        await faceDetectionService.predict(
            cameraImage!,
            _cameraService!.camera!.sensorOrientation,
            widget.studentsList!,
            widget.studentsProvavel!);
      }
    }
  }

  Future<void> _processImage(CameraImage cameraImage, int sensorOrientation,
      Orientation orientation) async {
    this.cameraImage = cameraImage;
    final rotation = getImageRotation(sensorOrientation, orientation);
    InputImage? inputImage =
        await convertCameraImageToInputImageWithRotate(cameraImage, rotation);

    if (inputImage == null || !_canProcess || _isBusy) return;
    _isBusy = true;
    faces = await faceDetectionService.faceDetector.processImage(inputImage);
    if (faces?.isEmpty ?? true) {
      _isFace = true;
      _isBusy = false;
      return;
    }
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
          [], faces!, inputImage.metadata!.size, sensorOrientation, rotation);
      _customPaint = CustomPaint(painter: painter);
    }
    _isBusy = false;

    if (mounted) {
      setState(
        () {
          if (widget.studentsList != null) {
            if ((_isFace == true)) {
              _isFace = false;
              _cameraTakeImage(imglib.encodeJpg(
                  convertCameraImageToImageWithRotate(cameraImage, rotation)));
            }
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    super.dispose();
  }
}
