import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../modelsView/user_face_detector_view.dart';
import '../models/stream_user_model.dart';

class UserFaceDetectorPage extends StatelessWidget {
  final String title;
  final StreamUser? user;
  final List<StreamUser>? users;
  final RxNotifier<List<StreamUser>>? userProvavel;
  final RxNotifier<bool>? isPhotoChanged;
  const UserFaceDetectorPage({
    super.key,
    required this.title,
    this.user,
    this.users,
    this.userProvavel,
    this.isPhotoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: UserFaceDetectorView(
          user: user,
          userList: users,
          userProvavel: userProvavel,
          stackFit: StackFit.expand,
          isPhotoChanged: isPhotoChanged,
        ));
  }
}
