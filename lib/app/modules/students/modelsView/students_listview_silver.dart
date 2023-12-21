import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constants.dart';
import '../students_controller.dart';
import '../models/stream_students_model.dart';
import 'students_face_detector_view.dart';

class StudentsListViewSilver extends StatelessWidget {
  final List<StreamStudents> list;
  final StudentsController controller;
  final StudentsFaceDetectorView? faceDetectorView;
  const StudentsListViewSilver({
    super.key,
    required this.controller,
    required this.list,
    this.faceDetectorView,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: controller.dateSelected,
      builder: (BuildContext context, String dateSelected, _) {
        /*
            int count = 0;
            for (var element in list) {
              if (element.chamada.toLowerCase().contains(data)) {
                count++;
              }
            }
            StreamStudents.countPresente = count;
        */
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (faceDetectorView != null)
              SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: faceDetectorView!),
            Expanded(
              child: CustomScrollView(
                semanticChildCount: list.length,
                slivers: <Widget>[
                  SliverSafeArea(
                    top: false,
                    minimum: const EdgeInsets.only(top: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < list.length) {
                            return Column(
                              children: <Widget>[
                                row(list[index], dateSelected),
                                index == list.length - 1
                                    ? const Padding(
                                        padding: EdgeInsets.only(bottom: 50))
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                          left: 100,
                                          right: 16,
                                        ),
                                        child: Container(
                                          height: 1,
                                          color: Styles.linhaProdutoDivisor,
                                        ),
                                      ),
                              ],
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget row(StreamStudents pessoa, String? dateSelected) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.only(
        left: 8,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: Row(
        children: <Widget>[
          FutureBuilder(
            future: pessoa.photoUint8List,
            builder: (BuildContext context, AsyncSnapshot photoUint8List) =>
                ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 0),
                child: photoUint8List.hasData
                    ? (photoUint8List.data as Uint8List).isEmpty
                        ? Image.asset(
                            "assets/images/semFoto.png",
                            fit: BoxFit.cover,
                            width: 76,
                            height: 76,
                          )
                        : Image.memory(
                            Uint8List.fromList(photoUint8List.data),
                            fit: BoxFit.cover,
                            width: 76,
                          )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${pessoa.firstname} ${pessoa.lastname}',
                    style: Styles.linhaProdutoNomeDoItem,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  if (pessoa.email.isEmpty)
                    Row(
                      children: [
                        Text(
                          pessoa.email,
                          style: Styles.linhaProdutoPrecoDoItem,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            //await abrirWhatsApp(pessoa.email);
                          },
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          dateSelected == null || dateSelected == ""
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  child: const Icon(
                    CupertinoIcons.hand_thumbsdown,
                    color: Colors.grey,
                    semanticLabel: 'Ausente',
                  ))
              : StreamBuilder(
                  initialData: pessoa,
                  stream: pessoa.chamadaStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<StreamStudents> assistido) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          assistido.data!.chamadaToogleFunc(dateSelected),
                      child: assistido.data?.chamada[dateSelected] == "P"
                          ? const Icon(
                              CupertinoIcons.hand_thumbsup,
                              color: Colors.green,
                              size: 30.0,
                              semanticLabel: 'Presente',
                            )
                          : const Icon(
                              CupertinoIcons.hand_thumbsdown,
                              color: Colors.red,
                              semanticLabel: 'Ausente',
                            ),
                    );
                  },
                ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Modular.to.pushNamed(
              "insert",
              arguments: {"students": pessoa},
            ),
            child: const Icon(
              Icons.edit,
              size: 30.0,
              color: Colors.blue,
              semanticLabel: 'Edit',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> abrirWhatsApp(String phoneNumber) async {
    late final String whatsappUrl;
    final phoneNumberClean = phoneNumber
        .replaceAll("-", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll(" ", "");
    //if (Platform.isAndroid) {
    //  whatsappUrl = "https://wa.me/55$phoneNumberClean&text=Olá";
    //} else {
    whatsappUrl = "whatsapp://send?phone=55$phoneNumberClean&text=";
    //}
    //Insert above line in android manifest
    //<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
}
