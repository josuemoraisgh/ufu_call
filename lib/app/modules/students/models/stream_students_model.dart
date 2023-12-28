import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../../utils/constants.dart';

import '../../../utils/models/students_model.dart';
import '../../../utils/models/token_model.dart';
import '../students_controller.dart';
import 'package:image/image.dart' as imglib;

class StreamStudents extends Students {
  Uint8List? _uint8ListImage;
  final StreamController<StreamStudents> _chamadaController =
      StreamController<StreamStudents>.broadcast();
  static final countPresenteController = RxNotifier<int>(0);
  final StudentsController controller = Modular.get<StudentsController>();
  StreamStudents(Students students)
      : super(
          id: students.id,
          firstname: students.firstname,
          lastname: students.lastname,
          email: students.email,
          photoName: students.photoName,
          chamada: students.chamada ?? {},
          fotoPoints: students.fotoPoints ?? [],
        );
  StreamStudents.vazio({int key = -1})
      : super(
          id: key,
          firstname: "",
          lastname: "",
          email: "",
          photoName: "",
          chamada: {},
          fotoPoints: [],
        );
  Stream<StreamStudents> get chamadaStream => _chamadaController.stream;

  Students get students => this;

  static int get countPresente => countPresenteController.value;
  static set countPresente(int value) {
    Future.delayed(const Duration(seconds: 0),
        () => countPresenteController.value = value);
  }

  Future<Uint8List> get photoUint8List async {
    if (_uint8ListImage != null) return _uint8ListImage!;
    Token token = await controller.configStorage.getUserToken();
    if ((photoName.isNotEmpty) && (photoName.contains("?rev="))) {
      final url =
          '${photoName.replaceFirst(APIConstants.API_BASE_URL, "${APIConstants.API_BASE_URL}webservice/")}&token=${token.token}';
      _uint8ListImage = (await NetworkAssetBundle(Uri.parse(url)).load(url))
          .buffer
          .asUint8List();
      if (_uint8ListImage!.isNotEmpty) {
        final image = imglib.decodeImage(_uint8ListImage!);
        if (image != null) {
          fotoPoints =
              (await controller.faceDetectionService.classificatorImage(image));
        }
      }
      return _uint8ListImage ?? Uint8List(0);
    }
    return Uint8List(0);
  }

  bool insertChamadaFunc(dateSelected) {
    if ((chamada != null) && (chamada!.containsKey(dateSelected))) {
      if (chamada![dateSelected] != "P") {
        chamada![dateSelected] = "P";
      }
    } else {
      if (chamada == null) {
        chamada = {dateSelected: "P"};
      } else {
        chamada?.addAll({dateSelected: "P"});
      }
    }
    atualizaChamada(dateSelected, 1);
    return true;
  }

  int chamadaToogleFunc(dateSelected) {
    if ((chamada != null) && (chamada!.containsKey(dateSelected))) {
      if (chamada![dateSelected] != "P") {
        chamada![dateSelected] = "P";
        atualizaChamada(dateSelected, 1);
        return 1;
      } else {
        chamada![dateSelected] = "";
        atualizaChamada(dateSelected, -1);
        return -1;
      }
    } else {
      if (chamada == null) {
        chamada = {dateSelected: "P"};
      } else {
        chamada?.addAll({dateSelected: "P"});
      }
      atualizaChamada(dateSelected, 1);
      return 1;
    }
  }

  atualizaChamada(String dateSelected, int value) async {
    _chamadaController.sink.add(this);
    Future.delayed(const Duration(seconds: 0),
        () => countPresenteController.value + value);
    await controller.chamadaGsheetProvider.putItem(
        table: 'ININDII',
        userName: '$firstname $lastname',
        date: dateSelected,
        value: chamada![dateSelected]!);
  }

  @override
  set chamada(Map<String, String>? value) {
    super.chamada = value;
    _chamadaController.sink.add(this);
  }
}
