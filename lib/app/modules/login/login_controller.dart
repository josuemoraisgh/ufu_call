import 'package:flutter_modular/flutter_modular.dart';

import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';

class LoginController {
  late final ConfigStorage moodleLocalStorage;
  late final MoodleProvider moodleProvider;
  LoginController(
      {ConfigStorage? moodleLocalStorage,
      MoodleProvider? moodleProvider}) {
    this.moodleLocalStorage =
        moodleLocalStorage ?? Modular.get<ConfigStorage>();
    this.moodleProvider = moodleProvider ?? Modular.get<MoodleProvider>();
  }
}
