import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../utils/constants.dart';
import 'models/students_models.dart';
import 'models/stream_students_model.dart';
import 'provider/students_provider_store.dart';

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
  late final StudentsProviderStore studentsProviderStore;

  StudentsController({StudentsProviderStore? studentsProviderStore}) {
    this.studentsProviderStore =
        studentsProviderStore ?? Modular.get<StudentsProviderStore>();
  }

  Future<void> init() async {
    if (isInitedController.value == false) {
      await studentsProviderStore.init();
      listenablStudents = (await studentsProviderStore.localStore.listenable());
      (await studentsProviderStore.syncStore.listenable())
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
        .where((students) =>
            // ignore: prefer_interpolation_to_compose_strings
            students.condicao.contains(RegExp(r"^(" + condicao + ")")))
        .where((students) => students.nomeM1
            .toLowerCase()
            .replaceAllMapped(
                RegExp(r'[\W\[\] ]'),
                (Match a) =>
                    caracterMap.containsKey(a[0]) ? caracterMap[a[0]]! : a[0]!)
            .contains(termosDeBusca.toLowerCase()))
        .toList()
      ..sort((a, b) {
        // Primeiro, comparar pelo campo nome
        int comparacao = a.nomeM1.compareTo(b.nomeM1);
        if (comparacao == 0) {
          return a.ident < b.ident ? -1 : 1;
        }
        return comparacao;
      });
  }

  Future<void> sync() async {
    if (await InternetConnectionChecker().hasConnection) {
      dynamic status;
      if (isRunningSync.value == false) {
        isRunningSync.value = true;
        countSync.value = await studentsProviderStore.syncStore.length();
        while (countSync.value > 0) {
          status = null;
          var sync = await (studentsProviderStore.syncStore.getSync(0)
            ..whenComplete(() => studentsProviderStore.syncStore.delSync(0)));
          if (sync != null) {
            if (sync.synckey == 'set') {
              status = await studentsProviderStore.remoteStore.setData(
                  (sync.syncValue as Students).ident.toString(),
                  (sync.syncValue as Students).toList());
            }
            if (sync.synckey == 'del') {
              status = await studentsProviderStore.remoteStore
                  .deleteData((sync.syncValue as String));
            }
            if (sync.synckey == 'addImage') {
              status = await studentsProviderStore.remoteStore.addFile(
                  'BDados_Images',
                  (sync.syncValue[0] as String),
                  (sync.syncValue[1] as Uint8List));
            }
            if (sync.synckey == 'setImage') {
              status = await studentsProviderStore.remoteStore.setFile(
                  'BDados_Images',
                  (sync.syncValue[0] as String),
                  (sync.syncValue[1] as Uint8List));
            }
            if (sync.synckey == 'delImage') {
              status = await studentsProviderStore.remoteStore
                  .deleteFile('BDados_Images', sync.syncValue);
            }
            if (sync.synckey == 'setConfig') {
              status = await studentsProviderStore.remoteStore.setData(
                  (sync.syncValue as List<String>)[0].toString(),
                  (sync.syncValue as List<String>).sublist(1).toList(),
                  table: 'Config');
            }
            if (status == null) {
              await studentsProviderStore.syncStore
                  .addSync(sync.synckey, sync.syncValue);
              break;
            }
          }
          countSync.value = await studentsProviderStore.syncStore.length();
        }
        var remoteConfigChanges =
            await studentsProviderStore.remoteStore.getChanges(table: "Config");
        if (remoteConfigChanges != null && remoteConfigChanges.isNotEmpty) {
          for (List e in remoteConfigChanges) {
            e.removeWhere((element) => element == "");
            final listString = e.sublist(1).cast<String>()[0];
            await studentsProviderStore.configStore.addConfig(
              e[0],
              listString.substring(listString.length - 1) == ";" &&
                      listString.substring(listString.length - 2) != ";"
                  ? listString.substring(0, listString.length - 1).split(";")
                  : listString.split(";"),
            );
          }
        }
        var remoteDataChanges =
            await studentsProviderStore.remoteStore.getChanges();
        if (remoteDataChanges != null) {
          for (var e in remoteDataChanges) {
            final stAssist =
                StreamStudents(Students.fromList(e), studentsProviderStore);
            studentsProviderStore.localStore.setRow(stAssist);
          }
        }
        isRunningSync.value = false;
      } else {
        await Future.delayed(
            const Duration(milliseconds: 500)); //so faz 10 requisições por vez.
        sync();
      }
    }
  }
}
