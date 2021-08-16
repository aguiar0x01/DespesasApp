import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/transaction.dart';
import '/components/chart.dart';
import '/components/transaction_list.dart';
import '/components/transaction_form.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple, // conjunto principal de  uma mesma cor
        accentColor: Colors.amber, // cor de realce/destaque
        fontFamily: "Quicksand",

        // definindo estilo de títulos do corpo da aplicação
        //textTheme: ThemeData.light().textTheme.copyWith(
        //      headline6: TextStyle(
        //        fontFamily: "Quicksand",
        //        fontWeight: FontWeight.bold,
        //        fontSize: 16,
        //      ),
        //    ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
              // título
              headline6: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold, // peso
                fontSize: 20,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/* no final da linha: 'with AlgumaCoisa' -> é um mixin, o código é 'injetado'
dentro da classe, em um modo análogo à herança. */
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  @override
  void initState() {
    // quando o estado é iniciado e os recursos são carregados
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    // quando estado da App está a entrar em suspensão
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // este método é chamado toda vez que o estado muda
    //print(state);
  }

  List<Transaction> get _recentTransactions {
    // filtra os 7 dias mais recentes da lista _transactions
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    /* Depois que todos os dados foram validados,
    fecha-se o Modal / entrada de texto
    -> o método .pop() remove o primeiro widget da pilha de widgets */
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(onSubmit: _addTransaction);
      },
    );
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    // Resolve problema de incompatibilidade com o IconButton no iOS
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    // operação ternária para escolha de ícones de acordo com o SO
    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.view_list;
    final iconChart =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    // ações dos botões
    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          // ícones diferentes para mostrar ou ocultar o Chart
          _showChart ? iconList : iconChart,
          () {
            setState(() {
              // inverte o estado e troca o botão no Android [->appBar]
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final appBar = AppBar(
      title: Text(
        "Despesas Pessoais",
        style: TextStyle(
          // resposividade na fonte
          fontSize: 18 * mediaQuery.textScaleFactor,
        ),
      ),
      actions: actions,
    );

    // cálculo da área do body disponível
    final avaiableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    // corpo da aplicação envolvido com componente de área segura
    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // em relação ao eixo Y, em alinhamento 'cruzado [X], o objeto é alinhado
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_showChart || !isLandscape)
              Container(
                height: avaiableHeight * (isLandscape ? 0.75 : 0.3),
                child: Chart(recentTransaction: _recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: avaiableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(
                  transactions: _transactions,
                  onRemoveTransaction: _removeTransaction,
                ),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyPage,
            navigationBar: CupertinoNavigationBar(
              middle: Text("Despesas pessoais"),
              trailing: Row(
                children: actions,
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            // ocultando o FloatButton, caso esteja no IOS
            floatingActionButton: Platform.isIOS
                ? Container() // container vazio
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
