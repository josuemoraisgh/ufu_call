import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../app_module.dart';
import '../../utils/provider/moodle_provider.dart';
import '../../utils/storage/config_storage.dart';
import 'pages/students_face_detector_page.dart';
import 'provider/chamada_gsheet_provider.dart';
import 'students_page.dart';
import 'services/face_detection_service.dart';
import 'students_controller.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class StudentsModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    i.addSingleton<StudentsController>(
      () => StudentsController(
        configStorage: i.get<ConfigStorage>(),
        moodleProvider: i.get<MoodleProvider>(),
        chamadaGsheetProvider: ChamadaGsheetProvider(provider: i.get<Dio>()),
        faceDetectionService: FaceDetectionService(
          faceDetector: FaceDetector(
            options: FaceDetectorOptions(
                performanceMode: FaceDetectorMode.accurate,
                enableContours: true),
          ),
        ),
      ),
    );
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => StudentsPage(
        courseId: r.args.data["courseId"],
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
