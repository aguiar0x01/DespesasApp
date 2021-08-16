import 'package:flutter/material.dart';
import './adaptative_button.dart';
import './adaptative_text_field.dart';
import './adaptative_date_picker.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  const TransactionForm({
    required this.onSubmit,
  });

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  /* TextEditingController() é a entrada de texto,
  relacionada ao TextField() */
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

  _onSubmitForm() {
    final title = _titleController.text;
    // faz a tentativa de parse, se não de certo, 0.0
    final value = double.tryParse(_valueController.text) ?? 0.0;

    // verifica valores válidos para o Modal
    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    // widget é uma forma de acessar elementos de uma classe Stateful
    widget.onSubmit(title, value, _selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
          /* quando o teclado é aberto, é considerado o tamanho dele
          para incrementar no tamanho do Modal (entrada do texto),
          e assim poder rolar o Modal dentro do Scroll */
          bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: <Widget>[
            AdaptativeTextField(
              // entrada de texto
              label: "Título",
              controller: _titleController,
              onSubmitted: (_) => _onSubmitForm(), // confirma a entrada
            ),
            AdaptativeTextField(
              // entrada de texto
              label: "Valor (R\$)",
              controller: _valueController,
              onSubmitted: (_) => _onSubmitForm(), // confirma a entrada
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            AdaptativeDatePicker(
                selectedDate: _selectedDate,
                // a data escolhida é passada indiretamente para newDate
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdaptativeButton(
                  label: "Nova transação",
                  bold: true,
                  onPressed: _onSubmitForm,
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
