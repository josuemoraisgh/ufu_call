import 'package:badges/badges.dart' as bg;
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../utils/models/course.dart';
import 'modelsView/students_listview_silver.dart';
import 'students_controller.dart';
import 'models/stream_students_model.dart';
import 'modelsView/students_face_detector_view.dart';
import 'modelsView/custom_search_bar.dart';
import 'modelsView/dropdown_body.dart';

class StudentsPage extends StatefulWidget {
  final Course course;
  const StudentsPage({super.key, required this.course});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final StudentsController controller = Modular.get<StudentsController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: controller.initController(widget.course),
      builder: (BuildContext context, AsyncSnapshot<bool> isInited) =>
          ValueListenableBuilder(
            valueListenable: controller.textEditing,
            builder:
                (BuildContext context, TextEditingValue textEditingValue, _) {
              List<StreamStudents>? list;
              if (isInited.hasData) {
                list = controller.search(
                  controller.studentsList.value,
                  textEditingValue.text,
                );
              }
              return Scaffold(
                appBar: customAppBar(),
                body: customBody(context, list ?? []),
                floatingActionButton: customFloatingActionButton(context),
              );
            },
          ));

  AppBar customAppBar() => AppBar(
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
                      ? controller.dateList.value.isNotEmpty
                          ? const Row(
                              children: [
                                Text(
                                  "Chamada: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      decorationColor: Colors.black),
                                ),
                                DropdownBody(
                                  selectedItemColor: Colors.white,
                                ),
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
                onPressed: () async {},
              ),
            ),
          ),
        ],
      );

  Widget customBody(
          BuildContext context, List<StreamStudents> studentsListFilted) =>
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
        child: studentsListFilted.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RxBuilder(
                builder: (BuildContext context) => StudentsListViewSilver(
                  controller: controller,
                  list: controller.faceDetector.value == true
                      ? controller.studentsProvavelList.value
                      : studentsListFilted,
                  faceDetectorView: controller.faceDetector.value == true
                      ? StudentsFaceDetectorView(
                          studentsList: studentsListFilted,
                          studentsProvavel: controller.studentsProvavelList)
                      : null,
                ),
              ),
      );

  Widget customFloatingActionButton(BuildContext context) => SpeedDial(
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
            backgroundColor: Colors.red,
            label: 'Chamada por Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              controller.faceDetector.value = !controller.faceDetector.value;
            },
          ),
          SpeedDialChild(
              child: const Icon(Icons.add_box),
              backgroundColor: Colors.blue,
              label: 'Alterar Chamada',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () async {
                controller.whatWidget.value = 0;
                await _checkDate(context);
                setState(() {});
              }),
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

  Future<bool> _checkDate(BuildContext context) async {
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
                  var itensRemove = controller.dateSelected.value;
                  if (controller.dateList.value.last != itensRemove) {
                    controller.dateSelected.value =
                        controller.dateList.value.last;
                  } else {
                    controller.dateSelected.value = controller.dateList.value
                        .elementAt(controller.dateList.value.length - 2);
                  }
                  controller.chamadaGsheetProvider
                      .del(table: widget.course.idnumber, date: itensRemove);
                  Modular.to.pop();
                },
                child: const Icon(Icons.remove, size: 24)),
            ElevatedButton(
                onPressed: () async {
                  await _insertData(context);
                },
                child: const Icon(Icons.add, size: 24)),
            ElevatedButton(
                onPressed: () {
                  //Navigator.of(context, rootNavigator: true).pop();
                  Modular.to.pop();
                },
                child: const Text("Close")),
          ],
          content: const DropdownBody(
            selectedItemColor: Colors.black,
          ),
        );
      },
    );
    return true;
  }

  Future<bool> _insertData(BuildContext context) async {
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
                  controller.chamadaGsheetProvider.put(
                      table: widget.course.shortname, date: value, value: "");
                  controller.dateList.value.add(value);
                  controller.dateSelected.value = value;
                  Modular.to.pop();
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
      },
    );
    return true;
  }
}
