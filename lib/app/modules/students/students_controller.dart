import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../utils/constants.dart';
import '../../utils/models/students_model.dart';
import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';
import 'models/stream_students_model.dart';
import 'provider/chamada_gsheet_provider.dart';
import 'services/face_detection_service.dart';

class StudentsController {
  final textEditing = TextEditingController(text: "");
  final dateSelected = RxNotifier<String>("");
  final isInitedController = RxNotifier<bool>(false);
  final focusNode = FocusNode();
  final whatWidget = RxNotifier<int>(0);
  final studentsProvavelList = RxNotifier<List<StreamStudents>>([]);
  final faceDetector = RxNotifier<bool>(false);
  final isRunningSync = RxNotifier<bool>(false);
  final countSync = RxNotifier<int>(0);

  late final ChamadaGsheetProvider chamadaGsheetProvider;
  late final ConfigStorage configStorage;
  late final MoodleProvider moodleProvider;
  late final FaceDetectionService faceDetectionService;

  StudentsController(
      {ChamadaGsheetProvider? chamadaGsheetProvider,
      ConfigStorage? configStorage,
      MoodleProvider? moodleProvider,
      FaceDetectionService? faceDetectionService}) {
    this.chamadaGsheetProvider =
        chamadaGsheetProvider ?? Modular.get<ChamadaGsheetProvider>();
    this.configStorage = configStorage ?? Modular.get<ConfigStorage>();
    this.moodleProvider = moodleProvider ?? Modular.get<MoodleProvider>();
    this.faceDetectionService =
        faceDetectionService ?? Modular.get<FaceDetectionService>();
  }

  Future<(List<Students>, List<String>)> init(String courseId) async {
    return (await getStudents(courseId), await geDateList());
  }

  Future<List<Students>> getStudents(String courseId) async {
    final token = await configStorage.getUserToken();
    return (await moodleProvider.getUsersByCourseId(courseId, token)).object
        as List<Students>;
  }

  Future<List<String>> geDateList() async {
    final list = await chamadaGsheetProvider.getItem(
        table: "ININDI", userName: "Nome", date: "");
    dateSelected.value = list.last;
    return list;
  }

  List<StreamStudents> search(
      List<StreamStudents> studentsList, termosDeBusca) {
    return studentsList
        .where((students) => (students.firstname + students.lastname)
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
