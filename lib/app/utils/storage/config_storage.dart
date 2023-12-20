import 'dart:async';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

class ConfigStorage {
  Completer<Box<List<String>>> configCompleter = Completer<Box<List<String>>>();

  Future<void> init() async {
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
    return Token.fromJson(json.decode(box.get(ConfigureKeys.USER_TOKEN)?[0] ?? ""));
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
}
