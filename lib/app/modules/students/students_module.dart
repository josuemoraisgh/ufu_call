import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../app_module.dart';
import 'pages/students_edit_insert_page.dart';
import 'pages/students_face_detector_page.dart';
import 'provider/students_provider_store.dart';
import 'services/remote_storage_service.dart';
import 'services/students_storage_service.dart';
import 'services/sync_storage_service.dart';
import 'students_page.dart';
import 'services/config_storage_service.dart';
import 'services/face_detection_service.dart';
import 'students_controller.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class StudentsModule extends Module {
  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void binds(Injector i) {
    i.addSingleton<StudentsController>(
      () => StudentsController(
        studentsProviderStore: StudentsProviderStore(
          syncStore: SyncStorageService(),
          localStore: StudentsStorageService(),
          configStore: ConfigStorageService(),
          remoteStore: StudentsRemoteStorageService(provider: Dio()),
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
      child: (_) => const StudentsPage(
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
      child: (_) => StudentsFaceDetectorPage(
        title: "Camera Ativa",
        students: r.args.data["students"],
        studentsList: r.args.data["studentsList"],
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
      child: (_) => StudentsEditInsertPage(
        students: r.args.data["students"],
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
