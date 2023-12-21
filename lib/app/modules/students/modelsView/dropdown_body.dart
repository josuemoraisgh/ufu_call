import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class DropdownBody extends StatefulWidget {
  final RxNotifier<String> dateSelected;
  final List<String> dateList;
  const DropdownBody(
      {super.key, required this.dateList, required this.dateSelected});

  @override
  State<DropdownBody> createState() => _DropdownBodyState();
}

class _DropdownBodyState extends State<DropdownBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.dateSelected,
      builder: (BuildContext context, String dateSelected, _) =>
          dateSelected != ""
              ? SizedBox(
                  height: 25,
                  child: DropdownButton<String>(
                    value: dateSelected,
                    onChanged: (String? novoItemSelecionado) {
                      if (novoItemSelecionado != null) {
                        widget.dateSelected.value = novoItemSelecionado;
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
                      return widget.dateList
                          .map((String value) {
                            return Text(
                              value,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            );
                          })
                          .toList()
                          .cast<Widget>();
                    },
                    items: widget.dateList
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
    );
  }
}
