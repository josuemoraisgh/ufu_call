import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../modules/students/services/face_detection_service.dart';
import 'camera_controle_service.dart';
import 'image_converter.dart';
import 'painters/face_detector_painter.dart';
import 'package:image/image.dart' as imglib;

class CameraPreviewWithPaint extends StatefulWidget {
  final CameraService cameraService;
  final FaceDetectionService faceDetectionService;
  final Future<void> Function(CameraImage cameraImage)? processImageStream;
  final Future<void> Function(CameraImage? cameraImage, Face? face)?
      takeImageFunc;
  final dynamic Function()? switchLiveCameraFunc;
  const CameraPreviewWithPaint({
    super.key,
    required this.cameraService,
    required this.faceDetectionService,
    this.processImageStream,
    this.takeImageFunc,
    this.switchLiveCameraFunc,
  });
  @override
  State<CameraPreviewWithPaint> createState() => _CameraPreviewWithPaintState();
}

class _CameraPreviewWithPaintState extends State<CameraPreviewWithPaint> {
  double _zoomLevel = 0.0, _minZoomLevel = 0.0, _maxZoomLevel = 0.0;
  bool _canProcess = true, _isBusy = false;
  int _faceSelected = 0;
  CameraImage? _cameraImage;
  List<Face>? _faces;
  Size _imageSize = const Size(0.0, 0.0);
  InputImageRotation _imageRotation = InputImageRotation.rotation0deg;
  final _dim = RxNotifier<List<(double, double, double, double)>>([]);
  bool _changingCameraLens = false;
  CustomPaint? _customPaint;
  late Future<bool> _isStarted; //Não retirar muito importante

  Future<bool> init() async {
    await _startLiveFeed(CameraLensDirection.back);
    return true;
  }

  @override
  void initState() {
    super.initState();
    _isStarted = init();
  }

  @override
  void dispose() {
    _canProcess = false;
    widget.cameraService.stopCameraController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isStarted,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if ((snapshot.data != null) &&
            (widget.cameraService.cameraController != null)) {
          if ((widget.cameraService.camera != null) &&
              (snapshot.hasData) &&
              (widget.cameraService.cameraController!.value.isInitialized)) {
            final imglib.Image? image = _cameraImage != null
                ? imgLibImageFromCameraImage(
                    _cameraImage!, widget.cameraService)
                : null;
            return LayoutBuilder(
              builder: (context, constraints) => Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  (widget.cameraService.cameraController?.value
                                  .isStreamingImages ??
                              true) ||
                          image == null
                      ? _changingCameraLens
                          ? const Center(child: Text('Changing camera lens'))
                          : CameraPreview(
                              widget.cameraService.cameraController!)
                      : Image.memory(
                          imglib.encodeJpg(image),
                          fit: BoxFit.fill,
                        ),
                  GestureDetector(
                    key: const ValueKey<int>(1),
                    onPanDown: (DragDownDetails details) {
                      if (_faces != null && _dim.value.isNotEmpty) {
                        for (int i = 0; i < _faces!.length; i++) {
                          if (details.localPosition.dx > _dim.value[i].$1 &&
                              details.localPosition.dy > _dim.value[i].$2 &&
                              details.localPosition.dx < _dim.value[i].$3 &&
                              details.localPosition.dy < _dim.value[i].$4) {
                            _faceSelected = i;
                            setState(() {
                              if (widget.takeImageFunc != null &&
                                  _faces != null) {
                                widget.takeImageFunc!(_cameraImage, _faces![i]);
                              }
                              _customPaint = CustomPaint(
                                painter: FaceDetectorPainter(
                                  _faces!,
                                  _faceSelected,
                                  _imageSize,
                                  _imageRotation,
                                  widget.cameraService.camera!.lensDirection,
                                  _dim,
                                ),
                              );
                            });
                          }
                        }
                      }
                    },
                    child: _customPaint,
                  ),
                  _floatingActionButton(),
                  _floatingActionSliderZoom(),
                  _floatingActionSliderThreshold(),
                ],
              ),
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _floatingActionSliderThreshold() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: RotatedBox(
        quarterTurns: 1,
        child: Slider(
          value: widget.faceDetectionService.threshold.value,
          min: 0.1,
          max: 2.0,
          onChanged: (newSliderValue) {
            setState(() =>
                widget.faceDetectionService.threshold.value = newSliderValue);
          },
          divisions: null,
        ),
      ),
    );
  }

  Widget _floatingActionSliderZoom() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: RotatedBox(
        quarterTurns: 1,
        child: Slider(
          value: _zoomLevel,
          min: _minZoomLevel,
          max: _maxZoomLevel,
          onChanged: (newSliderValue) {
            setState(() {
              _zoomLevel = newSliderValue;
              widget.cameraService.cameraController!.setZoomLevel(_zoomLevel);
            });
          },
          divisions: (_maxZoomLevel - 1).toInt() < 1
              ? null
              : (_maxZoomLevel - 1).toInt(),
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () {
                  _takeImageFunc();
                },
                child: Icon(
                  (widget.cameraService.camera!.lensDirection ==
                          CameraLensDirection.back)
                      ? Icons.photo_camera_back
                      : Icons.photo_camera_front,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(width: 24.0),
            ElevatedButton(
              onPressed: () {
                _switchLiveCamera();
              },
              child: Icon(
                Platform.isIOS
                    ? Icons.flip_camera_ios_outlined
                    : Icons.flip_camera_android_outlined,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startLiveFeed(CameraLensDirection cameraDirection) async {
    if (widget.cameraService.cameraController == null) {
      widget.cameraService.setupCameraController(
        cameraDirection: cameraDirection,
        initFunc: (_) async {
          if (!mounted) {
            return;
          }
          widget.cameraService.cameraController?.unlockCaptureOrientation();
          widget.cameraService.cameraController
              ?.getMinZoomLevel()
              .then((value) {
            _zoomLevel = value;
            _minZoomLevel = value;
          });
          widget.cameraService.cameraController
              ?.getMaxZoomLevel()
              .then((value) {
            _maxZoomLevel = value;
          });

          widget.cameraService.cameraController
              ?.startImageStream((cameraImage) {
            _processImageStream(cameraImage);
          });
          setState(() {});
        },
      );
    }
  }

  Future<void> _processImageStream(CameraImage cameraImage) async {
    _cameraImage = cameraImage;
    //final rotation = getImageRotation(sensorOrientation, orientation);
    InputImage? inputImage =
        inputImageFromCameraImage(cameraImage, widget.cameraService);
    if (inputImage == null || !_canProcess || _isBusy) return;
    _isBusy = true;
    _faces =
        await widget.faceDetectionService.faceDetector.processImage(inputImage);
    if (_faces?.isEmpty ?? true) {
      _isBusy = false;
      _customPaint = null;
      return;
    }
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      _imageSize = inputImage.metadata!.size;
      _imageRotation = inputImage.metadata!.rotation;
      _customPaint = CustomPaint(
        painter: FaceDetectorPainter(
          _faces!,
          _faceSelected,
          _imageSize,
          _imageRotation,
          widget.cameraService.camera!.lensDirection,
          _dim,
        ),
      );
    }
    _isBusy = false;
    if (mounted) {
      setState(
        () {
          if (widget.processImageStream != null) {
            widget.processImageStream!(cameraImage);
          }
        },
      );
    }
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    await widget.cameraService.stopCameraController();
    await _startLiveFeed(
        widget.cameraService.cameraDirection == CameraLensDirection.front
            ? CameraLensDirection.back
            : CameraLensDirection.front);
    if (widget.switchLiveCameraFunc != null) {
      await widget.switchLiveCameraFunc!();
    }
    setState(() => _changingCameraLens = false);
  }

  Future<void> _takeImageFunc() async {
    if (widget.cameraService.cameraController?.value.isStreamingImages ??
        false) {
      widget.cameraService.cameraController?.stopImageStream();
    } else {
      widget.cameraService.cameraController?.startImageStream((cameraImage) {
        _processImageStream(cameraImage);
      });
    }
    if (mounted) {
      setState(
        () {
          if (widget.takeImageFunc != null && _faces != null) {
            widget.takeImageFunc!(
                _cameraImage, _faces![_faceSelected]);
          }
        },
      );
    }
  }
}
