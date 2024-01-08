import 'package:flutter_modular/flutter_modular.dart';
import '../../app_module.dart';
import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';
import 'login_controller.dart';
import 'login_page.dart';

class LoginModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    i.add<LoginController>(() => LoginController(
          moodleLocalStorage: i.get<ConfigStorage>(),
          moodleProvider: i.get<MoodleProvider>(),
        ));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const LoginPage());
  }
}
