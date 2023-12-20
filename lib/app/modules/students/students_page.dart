import 'package:badges/badges.dart' as bg;
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../utils/models/students_model.dart';
import '../../utils/models/token_model.dart';
import 'modelsView/students_listview_silver.dart';
import 'students_controller.dart';
import 'models/stream_students_model.dart';
import 'modelsView/students_face_detector_view.dart';
import 'modelsView/custom_search_bar.dart';
import 'modelsView/dropdown_body.dart';

class StudentsPage extends StatefulWidget {
  final String courseId;
  final Token token;
  const StudentsPage({super.key, required this.courseId, required this.token});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final StudentsController controller = Modular.get<StudentsController>();
  final DropdownBody assistidosDropdownButton =
      DropdownBody(controller: Modular.get<StudentsController>());
  List<Students>? students;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> init() async {
    await controller.init();
    students = (await controller.moodleProvider
        .getUsersByCourseId(widget.courseId, widget.token)).object as List<Students>;
    return true;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<bool> isInited) =>
            isInited.data == true
                ? ValueListenableBuilder(
                      valueListenable: controller.textEditing,
                      builder: (BuildContext context,
                          TextEditingValue textEditingValue, _) {
                        List<StreamStudents> list = students!                        
                            .map((e) => StreamStudents(e))
                            .toList();
                        if (isInited.hasData) {
                          list = controller.search(
                            list,
                            textEditingValue.text,
                            'ATIVO',
                          );
                        }
                        return Scaffold(
                          appBar: customAppBar(isInited.hasData),
                          body: customBody(context, list),
                          floatingActionButton:
                              customFloatingActionButton(context, list),
                        );
                      },
                    ),
                  )
                : Scaffold(
                    appBar: customAppBar(isInited.hasData),
                    body: customBody(context, []),
                    floatingActionButton:
                        customFloatingActionButton(context, []),
                  ),
      );

  AppBar customAppBar(bool isInited) => AppBar(
        title: RxBuilder(
          builder: (BuildContext context) => bg.Badge(
            badgeStyle: bg.BadgeStyle(
                badgeColor: StreamStudents.countPresenteController.value == 0
                    ? Colors.red
                    : Colors.green),
            position: bg.BadgePosition.topStart(top: -10, start: -15),
            badgeContent: Text(
              '${StreamStudents.countPresenteController.value}',
              style: const TextStyle(color: Colors.white, fontSize: 10.0),
            ),
            child: RxBuilder(
              builder: (BuildContext context) =>
                  controller.whatWidget.value == 0
                      ? isInited
                          ? Row(
                              children: [
                                const Text(
                                  "Chamada: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      decorationColor: Colors.black),
                                ),
                                assistidosDropdownButton,
                              ],
                            )
                          : const Text("Inicializando")
                      : CustomSearchBar(
                          textController: controller.textEditing,
                          focusNode: controller.focusNode,
                        ),
            ),
          ),
        ),
        actions: <Widget>[
          RxBuilder(
            builder: (BuildContext context) => bg.Badge(
              badgeStyle: bg.BadgeStyle(
                  badgeColor: controller.countSync.value == 0
                      ? Colors.green
                      : Colors.red),
              position: bg.BadgePosition.topStart(top: 0, start: -2),
              badgeContent: Text(
                '${controller.countSync.value}',
                style: const TextStyle(color: Colors.white, fontSize: 10.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () async {
                  controller.sync();
                },
              ),
            ),
          ),
        ],
      );

  Widget customBody(BuildContext context, List<StreamStudents> studentsList) =>
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Color.fromRGBO(240, 240, 240, 0.5), BlendMode.modulate),
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: studentsList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RxBuilder(
                builder: (BuildContext context) => StudentsListViewSilver(
                  controller: controller,
                  list: controller.faceDetector.value == true
                      ? controller.studentsProvavelList.value
                      : studentsList,
                  faceDetectorView: controller.faceDetector.value == true
                      ? StudentsFaceDetectorView(
                          studentsList: studentsList,
                          studentsProvavel: controller.studentsProvavelList)
                      : null,
                ),
              ),
      );

  Widget customFloatingActionButton(
          BuildContext context, List<StreamStudents> assistidoList) =>
      SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Opções',
        heroTag: 'Seleciona Opções Diversas',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.collections),
            backgroundColor: Colors.purple,
            label: 'Reset Comunication',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () async {
              await controller.studentsProviderStore.remoteStore.resetAll();
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.collections),
            backgroundColor: Colors.red,
            label: 'Chamada por Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            /*onTap: () => chamadaTesteFunc(
                assistidos:
                    assistidoList), */
            onTap: () {
              controller.faceDetector.value = !controller.faceDetector.value;
            },
          ),
          SpeedDialChild(
              child: const Icon(Icons.add_box),
              backgroundColor: Colors.blue,
              label: 'Alterar Chamada',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {
                controller.whatWidget.value = 0;
                _checkDate(context);
              }),
          SpeedDialChild(
            child: const Icon(Icons.assignment_returned),
            backgroundColor: Colors.green,
            label: 'Inserir Usuário',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () => Modular.to.pushNamed(
              "insert",
              arguments: {"students": null},
            ),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.search,
            ),
            backgroundColor: Colors.yellow,
            label: 'Procurar',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              controller.whatWidget.value = 1;
            },
          ),
        ],
      );

  Future _checkDate(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text("Escolha a data da chamada"),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    final dateSelected = (await controller.studentsProviderStore
                        .getConfig("dateSelected"))?[0];
                    final itensList = await controller.studentsProviderStore
                        .getConfig("itensList");
                    if (itensList != null &&
                        dateSelected != null &&
                        itensList.length > 1) {
                      var itensRemove = dateSelected;
                      if (itensList.last != itensRemove) {
                        controller.studentsProviderStore
                            .setConfig("dateSelected", [itensList.last]);
                      } else {
                        controller.studentsProviderStore.setConfig(
                            "dateSelected",
                            [itensList.elementAt(itensList.length - 2)]);
                      }
                      final itens = itensList
                          .where((element) => element != itensRemove)
                          .toList();
                      controller.studentsProviderStore
                          .setConfig("itensList", itens);
                    } else {
                      //Fazer uma mensagem de erro informando que não pode remover todos os elementos.
                      debugPrint("Erro em dar presença!!!");
                    }
                  },
                  child:
                      const Icon(Icons.remove, color: Colors.white, size: 24)),
              ElevatedButton(
                  onPressed: () {
                    _insertData(context);
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 24)),
              ElevatedButton(
                  onPressed: () {
                    //Navigator.of(context, rootNavigator: true).pop();
                    Modular.to.pop();
                  },
                  child: const Text("Close")),
            ],
            content: assistidosDropdownButton,
          );
        });
  }

  void _insertData(BuildContext context) {
    String value = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text("Escolha a data da chamada"),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    //Navigator.of(context, rootNavigator: true).pop();
                    Modular.to.pop();
                  },
                  child: const Text("Cancelar")),
              ElevatedButton(
                  onPressed: () async {
                    final itensList = await controller.studentsProviderStore
                        .getConfig("itensList");
                    if (itensList != null) {
                      controller.studentsProviderStore
                          .setConfig("itensList", itensList + [value]);
                      controller.studentsProviderStore
                          .setConfig("dateSelected", [value]);
                      Modular.to.pop();
                    } else {
                      //Fazer uma mensagem de erro informando que não pode remover todos os elementos.
                      debugPrint(
                          "Erro itensList nulo!! Não é possível inserir dados.");
                    }
                  },
                  child: const Text("Salvar")),
            ],
            content: TextField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.date_range),
                    labelText: 'Informe a data'),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter(),
                ],
                onChanged: (v) {
                  value = v;
                }),
          );
        });
  }
}
