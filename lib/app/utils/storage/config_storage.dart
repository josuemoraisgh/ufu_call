import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ufu_call/app/utils/models/course.dart';
import '../constants.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

class ConfigStorage {
  Completer<Box<List<String>>> configCompleter = Completer<Box<List<String>>>();

  ConfigStorage() {
    _init();
  }

  Future<void> _init() async {
    if (!Hive.isBoxOpen('MoodleDatas')) {
      Hive.registerAdapter(TokenAdapter());
      Hive.registerAdapter(UserAdapter());
    }
    if (!configCompleter.isCompleted) {
      configCompleter.complete(await Hive.openBox<List<String>>('MoodleDatas'));
    }
  }

  Future<void> clear() async {
    final box = await configCompleter.future;
    await box.clear();
  }

  Future<bool> isUserLoggedIn() async {
    final box = await configCompleter.future;
    return box.get(ConfigureKeys.IS_USER_LOGGED_IN)?[0] == 'true';
  }

  Future<void> setUserLoggedIn(bool isLoggedIn) async {
    final box = await configCompleter.future;
    return box
        .put(ConfigureKeys.IS_USER_LOGGED_IN, [isLoggedIn ? 'true' : 'false']);
  }

  Future<User> getUserProfile() async {
    final box = await configCompleter.future;
    return User.fromJson(
        json.decode(box.get(ConfigureKeys.APP_USER)?[0] ?? ""));
  }

  Future<void> setUserProfile(User user) async {
    final box = await configCompleter.future;
    String userProfileJson = json.encode(user);
    return box.put(ConfigureKeys.APP_USER, [userProfileJson]);
  }

  Future<Token> getUserToken() async {
    final box = await configCompleter.future;
    return Token.fromJson(
        json.decode(box.get(ConfigureKeys.USER_TOKEN)?[0] ?? ""));
  }

  Future<void> setUserToken(Token token) async {
    final box = await configCompleter.future;
    String userTokenJson = json.encode(token);
    return box.put(ConfigureKeys.USER_TOKEN, [userTokenJson]);
  }

  Future<String> getSiteName() async {
    final box = await configCompleter.future;
    return json.decode(box.get(ConfigureKeys.SITE_NAME)?[0] ?? "");
  }

  Future<void> setSiteName(String token) async {
    final box = await configCompleter.future;
    String siteNameJson = json.encode(token);
    return box.put(ConfigureKeys.SITE_NAME, [siteNameJson]);
  }

  Future<String> getSiteUrl() async {
    final box = await configCompleter.future;
    return json.decode(box.get(ConfigureKeys.SITE_NAME)?[0] ?? '');
  }

  Future<void> setSiteUrl(String token) async {
    final box = await configCompleter.future;
    String siteUrlJson = json.encode(token);
    return box.put(ConfigureKeys.SITE_NAME, [siteUrlJson]);
  }

  Future<Course> getCourseSel() async {
    final box = await configCompleter.future;
    return Course.fromJson(
        json.decode(box.get(ConfigureKeys.COURSE_SEL)?[0] ?? ""));
  }

  Future<void> setCourseSel(Course course) async {
    final box = await configCompleter.future;
    String courseSelJson = json.encode(course);
    return box.put(ConfigureKeys.COURSE_SEL, [courseSelJson]);
  }

  Future<(String, Map<String, dynamic>)> getMapSync() async {
    final box = await configCompleter.future;
    final aux = box.get(ConfigureKeys.MAP_SYNC);
    return (
      aux?[0] ?? "",
      aux?[1] != null
          ? json.decode(aux![1]) as Map<String, dynamic>
          : <String, dynamic>{}
    );
  }

  Future<void> setMapSync(
      String courseShortName, Map<String, dynamic> mapSync) async {
    final box = await configCompleter.future;
    String mapSelJson = json.encode(mapSync);
    return box.put(ConfigureKeys.MAP_SYNC, [courseShortName, mapSelJson]);
  }

  Future<double?> getFaceThreshold() async {
    final box = await configCompleter.future;
    final aux = box.get(ConfigureKeys.FACE_THRESHOLD);
    return aux?[0] != null ? double.parse(aux![0]) : null;
  }

  Future<void> setFaceThreshold(double faceThreshold) async {
    final box = await configCompleter.future;
    return box.put(ConfigureKeys.FACE_THRESHOLD, [faceThreshold.toString()]);
  }

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

  Future<File> getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
    //file.readAsBytes();
  }

  Future<bool> delFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    if ((await File('${directory.path}/$fileName').exists()) == true) {
      await File('${directory.path}/$fileName').delete(recursive: true);
      return true;
    }
    return false;
  }
}
