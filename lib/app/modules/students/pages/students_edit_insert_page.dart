import 'package:flutter/material.dart';
import '../models/stream_students_model.dart';
import '../modelsView/students_insert_edit_view.dart';

class StudentsEditInsertPage extends StatelessWidget {
  final StreamStudents? students;
  const StudentsEditInsertPage({super.key, this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Insira/Edite o usuário!!")),
      body: StudentsInsertEditView(students: students),
    );
  }
}
