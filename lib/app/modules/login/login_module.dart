import 'package:flutter_modular/flutter_modular.dart';

import '../../app_module.dart';
import '../../utils/service/moodle_local_storage.dart';
import 'login_controller.dart';
import 'login_page.dart';

class LoginModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    i.addSingleton<LoginController>(
        () => LoginController(moodleLocalStorage: i.get<MoodleLocalStorage>()));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const LoginPage());
  }
}
