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
  final RxNotifier<List<StreamStudents>>? studentsProvavel;
  final List<StreamStudents>? studentsList;
  const StudentsFaceDetectorView(
      {super.key, this.studentsList, this.studentsProvavel});

  @override
  State<StudentsFaceDetectorView> createState() =>
      _StudentsFaceDetectorViewState();
}

class _StudentsFaceDetectorViewState extends State<StudentsFaceDetectorView> {
  late Future<bool> isInited;
  //bool _canProcess = true, _isBusy = false;
  CameraImage? cameraImage;
  final _controller = Modular.get<StudentsController>();
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

  Future<void> _takeImageFunc(CameraImage? cameraImage, Face? face) async {
    if (widget.studentsList != null) {
      if ((face != null) &&
          (cameraImage != null) &&
          (_cameraService.camera != null)) {
        widget.studentsProvavel!.value = await _faceDetectionService.predict(
          cameraImage,
          face,
          _cameraService,
          _controller.search(widget.studentsList!, "",
              isContains: false,
              item: _controller.dateSelected.value,
              condicao: "P"),
        );
      }
    }
  }

  @override
  void dispose() {
    //_canProcess = false;
    super.dispose();
  }
}
