import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../students_controller.dart';

class DropdownBody extends StatefulWidget {
  final Color? selectedItemColor;
  const DropdownBody({
    super.key,
    this.selectedItemColor,
  });

  @override
  State<DropdownBody> createState() => _DropdownBodyState();
}

class _DropdownBodyState extends State<DropdownBody> {
  final StudentsController controller = Modular.get<StudentsController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: controller.dateList,
      builder: (BuildContext context, List<String> dateList, _) =>
          ValueListenableBuilder<String>(
        valueListenable: controller.dateSelected,
        builder: (BuildContext context, String dateSelected, _) =>
            (dateSelected != "" &&
                    dateList.isNotEmpty &&
                    dateList.contains(dateSelected))
                ? SizedBox(
                    height: 25,
                    child: DropdownButton<String>(
                      value: dateSelected,
                      onChanged: (String? novoItemSelecionado) {
                        if (novoItemSelecionado != null) {
                          controller.dateSelected.value = novoItemSelecionado;
                        }
                      },
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      underline: Container(),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Theme.of(context).colorScheme.background,
                      focusColor: Theme.of(context).colorScheme.background,
                      selectedItemBuilder: (BuildContext context) {
                        return dateList
                            .map((String value) {
                              return Text(
                                value,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: widget.selectedItemColor,
                                ),
                              );
                            })
                            .toList()
                            .cast<Widget>();
                      },
                      items: dateList
                          .map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          })
                          .toList()
                          .cast<DropdownMenuItem<String>>(),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
