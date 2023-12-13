import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../faces/camera_controle_service.dart';
import '../../faces/camera_preview_with_paint.dart';
import '../../faces/image_converter.dart';
import '../provider/user_provider_store.dart';
import '../services/face_detection_service.dart';
import '../../faces/painters/face_detector_painter.dart';
import '../user_controller.dart';
import '../models/stream_user_model.dart';
import 'package:image/image.dart' as imglib;

class UserFaceDetectorView extends StatefulWidget {
  final RxNotifier<List<StreamUser>>? userProvavel;
  final RxNotifier<bool>? isPhotoChanged;
  final StreamUser? user;
  final List<StreamUser>? userList;
  final StackFit? stackFit;
  const UserFaceDetectorView(
      {super.key,
      this.userList,
      this.userProvavel,
      this.user,
      this.stackFit,
      this.isPhotoChanged});

  @override
  State<UserFaceDetectorView> createState() => _UserFaceDetectorViewState();
}

class _UserFaceDetectorViewState extends State<UserFaceDetectorView> {
  late Future<bool> isInited;
  late final UserProviderStore userProviderStore;
  late final FaceDetectionService faceDetectionService;
  bool _canProcess = true, _isBusy = false, _isFace = false;

  CameraService? _cameraService = Modular.get<CameraService>();
  CameraImage? cameraImage;
  List<Face>? faces;

  CustomPaint? _customPaint;

  Future<bool> init() async {
    userProviderStore = Modular.get<UserController>().userProviderStore;
    faceDetectionService = userProviderStore.faceDetectionService;
    _cameraService = _cameraService ?? CameraService();
    return true;
  }

  @override
  void initState() {
    super.initState();
    isInited = init();
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
            isRealTime: widget.userList != null,
            stackFit: widget.stackFit,
            initialDirection: CameraLensDirection.back,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _cameraTakeImage(Uint8List? uint8ListImage) async {
    if (widget.userList != null) {
      if ((faces?.isNotEmpty ?? false) &&
          (cameraImage != null) &&
          (_cameraService?.camera != null)) {
        if (faces!.length > 1) {
          debugPrint("duas faces");
        }
        await faceDetectionService.predict(
            cameraImage!,
            _cameraService!.camera!.sensorOrientation,
            widget.userList!,
            widget.userProvavel!);
      }
    } else {
      if ((widget.user != null) && (uint8ListImage != null)) {
        widget.user?.addSetPhoto(uint8ListImage);
        if (widget.isPhotoChanged != null) {
          widget.isPhotoChanged!.value = true;
        }
      }
      Modular.to.pop();
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
          if (widget.userList != null) {
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
