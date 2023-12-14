import 'package:flutter_modular/flutter_modular.dart';
import 'package:ufu_call/app/utils/service/moodle_local_storage.dart';
import 'modules/students/students_module.dart';
import 'modules/config/config_module.dart';
import 'modules/info/info_module.dart';
import 'modules/login/login_module.dart';
import 'notfound_page.dart';
import 'splash_page.dart';
import 'utils/faces/camera_controle_service.dart';

class AppModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addInstance<CameraService>(CameraService());
    i.addInstance<MoodleLocalStorage>(MoodleLocalStorage());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
    r.module('/user', module: StudentsModule());
    r.module('/login', module: LoginModule());
    r.module('/config', module: ConfigModule());
    r.module('/info', module: InfoModule());
    r.wildcard(child: (context) => const NotFoundPage());
  }
}
