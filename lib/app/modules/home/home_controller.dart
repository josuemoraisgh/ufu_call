import 'package:flutter_modular/flutter_modular.dart';

import '../../utils/service/moodle_local_storage.dart';

class HomeController {
  late final MoodleLocalStorage moodleLocalStorage;
  HomeController({MoodleLocalStorage? moodleLocalStorage}) {
    this.moodleLocalStorage =
        moodleLocalStorage ?? Modular.get<MoodleLocalStorage>();
  }
}
