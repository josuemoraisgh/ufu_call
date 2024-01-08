import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ufu_call/app/utils/storage/config_storage.dart';
import 'modules/students/provider/chamada_gsheet_provider.dart';
import 'modules/students/students_module.dart';
import 'modules/config/config_module.dart';
import 'modules/info/info_module.dart';
import 'modules/login/login_module.dart';
import 'modules/home/home_module.dart';
import 'notfound_page.dart';
import 'splash_page.dart';
import 'utils/faces/camera_controle_service.dart';
import 'utils/provider/moodle_provider.dart';

final dio = Dio();

class AppModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<Dio>(() => dio);
    i.add<CameraService>(CameraService.new);
    i.add<ConfigStorage>(ConfigStorage.new);
    i.add<MoodleProvider>(() => MoodleProvider(providerHttp: dio));
    i.add<ChamadaGsheetProvider>(() => ChamadaGsheetProvider(provider: dio));
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
    r.module('/students', module: StudentsModule());
    r.module('/home', module: HomeModule());
    r.module('/login', module: LoginModule());
    r.module('/config', module: ConfigModule());
    r.module('/info', module: InfoModule());
    r.wildcard(child: (context) => const NotFoundPage());
  }
}
