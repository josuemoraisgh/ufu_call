import 'package:flutter_modular/flutter_modular.dart';
import '../../utils/models/course.dart';
import '../../utils/models/token_model.dart';
import '../../utils/models/user_model.dart';
import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';

class HomeController {
  late final ConfigStorage moodleLocalStorage;
  late final MoodleProvider moodleProvider;
  HomeController(
      {ConfigStorage? moodleLocalStorage, MoodleProvider? moodleProvider}) {
    this.moodleLocalStorage =
        moodleLocalStorage ?? Modular.get<ConfigStorage>();
    this.moodleProvider = moodleProvider ?? Modular.get<MoodleProvider>();
  }

  Future<(User, Token, List<Course>)> initUserProfile() async {
    final user = await moodleLocalStorage.getUserProfile();
    final token = await moodleLocalStorage.getUserToken();
    final courses = (await moodleProvider.getUserCourses(token, user)).object
        as List<Course>;
    return (user, token, courses);
  }
}
