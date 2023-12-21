import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../modelsView/students_face_detector_view.dart';
import '../models/stream_students_model.dart';

class StudentsFaceDetectorPage extends StatelessWidget {
  final String title;
  final StreamStudents? students;
  final List<StreamStudents>? studentsList;
  final RxNotifier<List<StreamStudents>>? studentsProvavel;
  final RxNotifier<bool>? isPhotoChanged;
  const StudentsFaceDetectorPage({
    super.key,
    required this.title,
    this.students,
    this.studentsList,
    this.studentsProvavel,
    this.isPhotoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: StudentsFaceDetectorView(
          studentsList: studentsList,
          studentsProvavel: studentsProvavel,
          stackFit: StackFit.expand,
          isPhotoChanged: isPhotoChanged,
        ));
  }
}
