import 'package:flutter_modular/flutter_modular.dart';

import '../../utils/provider/moodle_provider.dart';
import '../../utils/service/moodle_local_storage.dart';

class HomeController {
  late final MoodleLocalStorage moodleLocalStorage;
  late final MoodleProvider moodleProvider;
  HomeController(
      {MoodleLocalStorage? moodleLocalStorage,
      MoodleProvider? moodleProvider}) {
    this.moodleLocalStorage =
        moodleLocalStorage ?? Modular.get<MoodleLocalStorage>();
    this.moodleProvider = moodleProvider ?? Modular.get<MoodleProvider>();
  }
}
