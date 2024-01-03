import 'package:flutter_modular/flutter_modular.dart';
import '../../utils/constants.dart';
import '../../utils/models/course.dart';
import '../../utils/models/event_object.dart';
import '../../utils/models/token_model.dart';
import '../../utils/models/user_model.dart';
import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';
import '../students/provider/chamada_gsheet_provider.dart';

class HomeController {
  User? user;
  Token? token;
  List<Course>? courses;

  late final ConfigStorage moodleLocalStorage;
  late final MoodleProvider moodleProvider;
  late final ChamadaGsheetProvider chamadaGsheetProvider;

  HomeController(
      {ConfigStorage? moodleLocalStorage,
      MoodleProvider? moodleProvider,
      ChamadaGsheetProvider? chamadaGsheetProvider}) {
    this.moodleLocalStorage =
        moodleLocalStorage ?? Modular.get<ConfigStorage>();
    this.moodleProvider = moodleProvider ?? Modular.get<MoodleProvider>();
    this.chamadaGsheetProvider =
        chamadaGsheetProvider ?? Modular.get<ChamadaGsheetProvider>();
  }

  Future<bool> initUserProfile() async {
    sync();
    user = await moodleLocalStorage.getUserProfile();
    token = await moodleLocalStorage.getUserToken();
    final EventObject ev = (await moodleProvider.getUserCourses(token!, user!));
    courses = ev.object as List<Course>;
    if (ev.id != EventConstants.LOGIN_USER_SUCCESSFUL) {
      await moodleLocalStorage.setUserLoggedIn(false);
      Modular.to.pushNamed("/login/");
    }
    return true;
  }

  void sync() async {
    final (table, value) = await moodleLocalStorage.getMapSync();
    if (value.isNotEmpty) {
      await chamadaGsheetProvider.put(
        table: table,
        userName: '',
        date: '',
        value: value, //mapSync.value,
      );
      moodleLocalStorage.setMapSync("", {}); //mapSync.value = {};
    }
  }
}
