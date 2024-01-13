import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final int listSelected;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  FaceDetectorPainter(
    this.faces,
    this.listSelected,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < faces.length; i++) {
      final left = translateX(
        faces[i].boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateY(
        faces[i].boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateX(
        faces[i].boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = translateY(
        faces[i].boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4 - 0.0
          ..color = i == listSelected ? Colors.green : Colors.red,
      );
/*
      void paintContour(FaceContourType type) {
        final contour = face.contours[type];
        if (contour?.points != null) {
          for (final Point point in contour!.points) {
            canvas.drawCircle(
                Offset(
                  translateX(
                    point.x.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  ),
                  translateY(
                    point.y.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  ),
                ),
                1,
                paint1);
          }
        }
      }
      for (final type in FaceContourType.values) {
        paintContour(type);
      }

      void paintLandmark(FaceLandmarkType type) {
        final landmark = face.landmarks[type];
        if (landmark?.position != null) {
          canvas.drawCircle(
              Offset(
                translateX(
                  landmark!.position.x.toDouble(),
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  landmark.position.y.toDouble(),
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
              ),
              2,
              paint2);
        }
      }
      for (final type in FaceLandmarkType.values) {
        paintLandmark(type);
      }
      */
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}
