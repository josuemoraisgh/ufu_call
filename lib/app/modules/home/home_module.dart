import 'package:flutter_modular/flutter_modular.dart';

import '../../app_module.dart';
import '../../utils/storage/config_storage.dart';
import 'home_controller.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    i.addSingleton<HomeController>(
        () => HomeController(moodleLocalStorage: i.get<ConfigStorage>()));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomePage());
  }
}
