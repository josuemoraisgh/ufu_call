import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../modelsView/user_face_detector_view.dart';
import '../models/stream_user_model.dart';

class UserFaceDetectorPage extends StatelessWidget {
  final String title;
  final StreamUser? assistido;
  final List<StreamUser>? assistidos;
  final RxNotifier<List<StreamUser>>? assistidoProvavel;
  final RxNotifier<bool>? isPhotoChanged;
  const UserFaceDetectorPage({
    super.key,
    required this.title,
    this.assistido,
    this.assistidos,
    this.assistidoProvavel,
    this.isPhotoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: UserFaceDetectorView(
          assistido: assistido,
          assistidoList: assistidos,
          assistidoProvavel: assistidoProvavel,
          stackFit: StackFit.expand,
          isPhotoChanged: isPhotoChanged,
        ));
  }
}
