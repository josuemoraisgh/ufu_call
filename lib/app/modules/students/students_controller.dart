import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../utils/constants.dart';
import '../../utils/models/course.dart';
import '../../utils/models/students_model.dart';
import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';
import 'models/stream_students_model.dart';
import 'provider/chamada_gsheet_provider.dart';
import 'services/face_detection_service.dart';

class StudentsController {
  final isInitedController = RxNotifier<bool>(false);

  final studentsList = RxNotifier<List<StreamStudents>>([]);
  final studentsProvavelList = RxNotifier<List<StreamStudents>>([]);
  final dateList = RxNotifier<List<String>>([]);
  final dateSelected = RxNotifier<String>("");
  final countPresenteController = RxNotifier<int>(0);

  final textEditing = TextEditingController(text: "");
  final focusNode = FocusNode();
  final whatWidget = RxNotifier<int>(0);

  final faceDetector = RxNotifier<bool>(false);

  final isRunningSync = RxNotifier<bool>(false);
  final countSync = RxNotifier<int>(0);
  final mapSync = RxNotifier<Map<String, Map<String, String>>>({});

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

  Future<bool> initController(Course course) async {
    countPresenteController.value = 0;
    studentsList.value = (await getStudents(course))
        .map((e) => StreamStudents(e, sortNameCourse: course.shortname))
        .toList();
    dateList.value = await geDateList(course);
    dateSelected.addListener(() {
      countPresenteController.value = 0;
      getStudentChamadaValue(course);
    });
    dateSelected.value = dateList.value.last;
    return true;
  }

  getStudentChamadaValue(Course course) async {
    final values = await chamadaGsheetProvider.get(table: course.shortname);
    final index = values['Nome']!.indexOf(dateSelected.value);
    if (index >= 0) {
      for (var e in studentsList.value) {
        if (values['${e.firstname} ${e.lastname}']?[index] == "P") {
          e.insertChamadaFunc(dateSelected.value, isAtualiza: false);
        }
      }
    }
  }

  Future<List<Students>> getStudents(Course course) async {
    final token = await configStorage.getUserToken();
    List<Students> studentsList =
        (await moodleProvider.getUsersByCourseId(course.id.toString(), token))
            .object as List<Students>;
    return studentsList;
  }

  Future<List<String>> geDateList(Course course) async {
    List list = (await chamadaGsheetProvider.get(
        table: course.shortname, userName: "Nome", date: ""))["Nome"];
    list = list.isEmpty ? [DateFormat('dd/MM').format(DateTime.now())] : list;
    dateSelected.value = list.last;
    return list.map((e) => e.toString()).toList();
  }

  List<StreamStudents> search(
      List<StreamStudents> studentsList, String termosDeBusca) {
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
        int comparacao =
            a.firstname.toLowerCase().compareTo(b.firstname.toLowerCase());
        if (comparacao == 0) {
          return a.lastname.toLowerCase().compareTo(b.lastname.toLowerCase());
        }
        return comparacao;
      });
  }

  void sync(Course course) async {
    if (isRunningSync.value == false) {
      Future.delayed(
          const Duration(seconds: 0), () => isRunningSync.value = true);
      await chamadaGsheetProvider.put(
        table: course.shortname,
        userName: '',
        date: '',
        value: mapSync.value,
      );
      countSync.value = 0;
      mapSync.value = {};
      Future.delayed(
          const Duration(seconds: 0), () => isRunningSync.value = false);
    }
  }
}
