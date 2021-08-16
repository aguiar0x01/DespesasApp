import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final void Function(DateTime?) onDateChanged;

  const AdaptativeDatePicker({
    required this.selectedDate,
    required this.onDateChanged,
  });

  // void Function() {} ;; Android Calendar
  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context, // context é passado via herança para o State<>
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      onDateChanged(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            height: 180,
            // IOS Calendar
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2020),
              maximumDate: DateTime.now(),
              onDateTimeChanged: onDateChanged,
            ),
          )
        // Android Calendar
        : Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? "Nenhuma data selecionada!"
                        : "Data selecionada: ${DateFormat("dd/MM/y").format(selectedDate!)}",
                  ),
                ),
                TextButton(
                  onPressed: () => _showDatePicker(context),
                  child: Text("Selecionar data",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          );
  }
}
