import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../../utils/faces/camera_controle_service.dart';
import '../../../utils/faces/camera_preview_with_paint.dart';
import '../students_controller.dart';
import '../models/stream_students_model.dart';

class StudentsFaceDetectorView extends StatefulWidget {
  final RxNotifier<List<List<StreamStudents>>>? studentsProvavel;
  final List<StreamStudents>? studentsList;
  final RxNotifier<int>? faceSelected;
  const StudentsFaceDetectorView(
      {super.key, this.studentsList, this.studentsProvavel, this.faceSelected});

  @override
  State<StudentsFaceDetectorView> createState() =>
      _StudentsFaceDetectorViewState();
}

class _StudentsFaceDetectorViewState extends State<StudentsFaceDetectorView> {
  late Future<bool> isInited;
  //bool _canProcess = true, _isBusy = false;
  CameraImage? cameraImage;
  final _cameraService = Modular.get<CameraService>();
  final _faceDetectionService =
      Modular.get<StudentsController>().faceDetectionService;

  Future<bool> init() async {
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
            faceDetectionService: _faceDetectionService,
            processImageStream: null,
            takeImageFunc: _takeImageFunc,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _takeImageFunc(
      CameraImage? cameraImage, List<Face>? faces) async {
/*     if (widget.studentsList != null) {
      if ((faces?.isNotEmpty ?? false) &&
          (cameraImage != null) &&
          (_cameraService.camera != null)) {
        widget.faceSelected?.value = 0;
        await _faceDetectionService.predict(cameraImage, faces!, _cameraService,
            widget.studentsList!, widget.studentsProvavel!);
      }
    } */
  }

  @override
  void dispose() {
    //_canProcess = false;
    super.dispose();
  }
}
