import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../interfaces/user_storage_interface.dart';
import '../models/user_models.dart';

//implements == interface
class UserStorageService implements UserStorageInterface {
  Completer<Box<User>> completerAssistidos = Completer<Box<User>>();

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen('assistidosDados')) {
      Hive.registerAdapter(UserAdapter());
    }
    if (!completerAssistidos.isCompleted) {
      completerAssistidos.complete(await Hive.openBox<User>('assistidosDados'));
    }
  }

  @override
  Future<ValueListenable<Box<User>>> listenable({List<dynamic>? keys}) async {
    final box = await completerAssistidos.future;
    return box.listenable();
  }

  @override
  Stream<BoxEvent> watch(String key) async* {
    final box = await completerAssistidos.future;
    yield* box.watch(key: key);
  }

  @override
  Future<String?> setRow(User? data) async {
    if (data != null) {
      if (data.ident > 0) {
        final box = await completerAssistidos.future;
        box.put(data.ident, data);
        return "SUCCESS";
      }
    }
    return "ROW NOT FOUND";
  }

  @override
  Future<User?> getRow(int rowId) async {
    final box = await completerAssistidos.future;
    return box.get(rowId);
  }

  @override
  Future<List<dynamic>> getKeys() async {
    final box = await completerAssistidos.future;
    return box.keys.toList();
  }

  @override
  Future<List<User>> getAll() async {
    final box = await completerAssistidos.future;
    return box.values.toList();
  }

  @override
  Future<bool> delRow(String row) async {
    try {
      final box = await completerAssistidos.future;
      box.delete(row);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delAll() async {
    try {
      await Hive.deleteBoxFromDisk('assistidosDados');
      final box = await Hive.openBox<User>('assistidosDados');
      completerAssistidos = Completer<Box<User>>();
      if (!completerAssistidos.isCompleted) completerAssistidos.complete(box);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<File> addSetFile(
      String fileName, final Uint8List uint8ListImage) async {
    final directory = await getApplicationDocumentsDirectory();
    //var buffer = uint8ListImage.buffer;
    //ByteData byteData = ByteData.view(buffer);
    return File('${directory.path}/$fileName')
      ..writeAsBytesSync(List<int>.from(uint8ListImage),
          mode: FileMode.writeOnly, flush: true);
    //return await File('${directory.path}/$fileName').writeAsBytes(
    //    buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    //    mode: FileMode.writeOnly,flush: true);
  }

  @override
  Future<File> getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
    //file.readAsBytes();
  }

  @override
  Future<bool> delFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    if ((await File('${directory.path}/$fileName').exists()) == true) {
      await File('${directory.path}/$fileName').delete(recursive: true);
      return true;
    }
    return false;
  }
}
