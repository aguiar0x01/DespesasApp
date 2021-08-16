import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemoveTransaction;

  const TransactionList({
    required this.transactions,
    required this.onRemoveTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                SizedBox(height: constraints.maxHeight * 0.02),
                const Text(
                  "Nenhuma Transação Cadastrada",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
                Container(
                  height: constraints.maxHeight * 0.4,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return TransactionItem(
                tr: tr,
                onRemoveTransaction: onRemoveTransaction,
              );
            },
          );
  }
}
