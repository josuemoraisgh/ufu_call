import 'package:flutter_modular/flutter_modular.dart';

import '../../app_module.dart';
import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';
import '../students/provider/chamada_gsheet_provider.dart';
import 'home_controller.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    i.addSingleton<HomeController>(() => HomeController(
          moodleLocalStorage: i.get<ConfigStorage>(),
          moodleProvider: i.get<MoodleProvider>(),
          chamadaGsheetProvider: i.get<ChamadaGsheetProvider>(),
        ));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomePage());
  }
}
