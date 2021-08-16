import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction tr;
  final void Function(String) onRemoveTransaction;

  const TransactionItem({
    Key? key,
    required this.tr,
    required this.onRemoveTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text("R\$${tr.value}"),
            ),
          ),
        ),
        title: Text(
          tr.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        subtitle: Text(
          DateFormat("d MMM y").format(tr.date),
        ),
        trailing: MediaQuery.of(context).size.width > 480
            ? TextButton.icon(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => onRemoveTransaction(tr.id),
                label: Text(
                  "Excluir",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ))
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => onRemoveTransaction(tr.id),
              ),
      ),
    );
  }
}
