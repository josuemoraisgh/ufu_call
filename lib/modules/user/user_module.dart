import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../app_module.dart';
import 'provider/user_provider_store.dart';
import 'services/sync_storage_service.dart';
import 'pages/user_face_detector_page.dart';
import 'user_page.dart';
import 'pages/user_edit_insert_page.dart';
import 'services/remote_storage_service.dart';
import 'services/user_storage_service.dart';
import 'services/config_storage_service.dart';
import 'services/face_detection_service.dart';
import 'user_controller.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class UserModule extends Module {
  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void binds(Injector i) {
    i.addSingleton<UserController>(
      () => UserController(
        assistidosProviderStore: UserProviderStore(
          syncStore: SyncStorageService(),
          localStore: UserStorageService(),
          configStore: ConfigStorageService(),
          remoteStore: AssistidoRemoteStorageService(provider: Dio()),
          faceDetectionService: FaceDetectionService(
            faceDetector: FaceDetector(
              options: FaceDetectorOptions(
                  performanceMode: FaceDetectorMode.accurate,
                  enableContours: true),
            ),
          ),
        ),
      ),
    );
    /*i.addInstance<AssistidosController>(
      AssistidosController(
        assistidosStoreList: AssistidosStoreList(
          syncStore: SyncStorageService(),
          localStore: AssistidoStorageService(),
          configStore: ConfigStorageService(),
          remoteStore: AssistidoRemoteStorageService(provider: Dio()),
          faceDetectionService: FaceDetectionService(),
        ),
      ),
    );*/
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const UserPage(
        dadosTela: {
          'id': 1,
          'title': 'Alunos',
          'img': 'assets/images/background.png',
          'active': 1
        },
      ),
      transition: TransitionType.custom,
      customTransition: CustomTransition(
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1,
            child: child,
          );
        },
      ),
    );
    r.child(
      '/faces',
      child: (_) => UserFaceDetectorPage(
        title: "Camera Ativa",
        assistido: r.args.data["assistido"],
        assistidos: r.args.data["assistidos"],
        isPhotoChanged: r.args.data["isPhotoChanged"],
      ),
      transition: TransitionType.custom,
      customTransition: CustomTransition(
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1,
            child: child,
          );
        },
      ),
    );
    r.child(
      '/insert',
      child: (_) => UserEditInsertPage(
        assistido: r.args.data["assistido"],
      ),
      transition: TransitionType.custom,
      customTransition: CustomTransition(
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1,
            child: child,
          );
        },
      ),
    );
  }
}

class CustomTransitionBuilder extends PageTransitionsBuilder {
  const CustomTransitionBuilder();
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    final tween =
        Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease));
    return ScaleTransition(
        scale: animation.drive(tween),
        child: FadeTransition(opacity: animation, child: child));
  }
}
