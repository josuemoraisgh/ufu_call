import 'package:flutter_modular/flutter_modular.dart';

import '../../utils/service/moodle_local_storage.dart';

class LoginController {
  late final MoodleLocalStorage moodleLocalStorage;
  LoginController({MoodleLocalStorage? moodleLocalStorage}) {
    this.moodleLocalStorage =
        moodleLocalStorage ?? Modular.get<MoodleLocalStorage>();
  }
}
