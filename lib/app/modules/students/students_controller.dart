import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../utils/constants.dart';
import '../../utils/models/students_model.dart';
import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';
import 'models/stream_students_model.dart';
import 'provider/chamada_gsheet_provider.dart';

class StudentsController {
  final textEditing = TextEditingController(text: "");
  final isInitedController = RxNotifier<bool>(false);
  final focusNode = FocusNode();
  final whatWidget = RxNotifier<int>(0);
  final studentsProvavelList = RxNotifier<List<StreamStudents>>([]);
  final faceDetector = RxNotifier<bool>(false);
  final isRunningSync = RxNotifier<bool>(false);
  final countSync = RxNotifier<int>(0);

  late final ValueListenable<Box<Students>> listenablStudents;
  late final ChamadaGsheetProvider chamadaGsheetProvider;

  late final ConfigStorage moodleLocalStorage;
  late final MoodleProvider moodleProvider;

  StudentsController(
      {ChamadaGsheetProvider? chamadaGsheetProvider,
      ConfigStorage? moodleLocalStorage,
      MoodleProvider? moodleProvider}) {
    this.chamadaGsheetProvider =
        chamadaGsheetProvider ?? Modular.get<ChamadaGsheetProvider>();
    this.moodleLocalStorage =
        moodleLocalStorage ?? Modular.get<ConfigStorage>();
    this.moodleProvider = moodleProvider ?? Modular.get<MoodleProvider>();
  }

  Future<void> init() async {
    if (isInitedController.value == false) {
      listenablStudents = (await chamadaGsheetProvider.localStore.listenable());
      (await ChamadaGsheetProvider.syncStore.listenable())
          .addListener(() => sync());
      await sync();
      isInitedController.value = true;
    } else {
      sync();
    }
  }

  List<StreamStudents> search(
      List<StreamStudents> studentsList, termosDeBusca, String condicao) {
    return studentsList
        .where((students) => (students.firstname+students.lastname)
            .toLowerCase()
            .replaceAllMapped(
                RegExp(r'[\W\[\] ]'),
                (Match a) =>
                    caracterMap.containsKey(a[0]) ? caracterMap[a[0]]! : a[0]!)
            .contains(termosDeBusca.toLowerCase()))
        .toList()
      ..sort((a, b) {
        // Primeiro, comparar pelo campo nome
        int comparacao = a.firstname.compareTo(b.firstname);
        if (comparacao == 0) {
          return a.lastname.compareTo(b.lastname);
        }
        return comparacao;
      });
  }
}