import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'widgets/transactionList.dart';
import 'widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
        fontFamily: 'OpenSans',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [];

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  void _addTransaction(String txtitle, double txamount, DateTime _date) {
    final newTr = Transaction(
        title: txtitle,
        amount: txamount,
        date: _date,
        id: DateTime.now().toString());
    setState(() {
      _userTransaction.add(newTr);
    });
  }

  void _remove(Transaction tr) {
    setState(() {
      _userTransaction.remove(tr);
    });
  }

  void _startAddTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            //this constractor for avoid closing the sheet when tap on it
            onTap: () {},
            child: NewTransaction(_addTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  bool showChart = false;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, //only as big as childrens need
              children: <Widget>[
                GestureDetector(
                  //IconBotton not work on IOS becouse it want material design
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            // we use type PreferredSizeWidget becouse dart dont know that CupertinoNavigationBa
            // also have preferred size
            title: Text('Personal Expenses'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddTransaction(context),
              )
            ],
          );
    final _onlandWidget = Column(
      // mainAxisAlignment: MainAxisAlignment.start,

      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Show Chart',
              style: Theme.of(context).textTheme.title,
            ),
            Switch.adaptive(
              value: showChart,
              activeColor: Theme.of(context).accentColor,
              onChanged: (val) {
                setState(() {
                  showChart = val;
                });
              },
            )
          ],
        ),
        showChart
            ? Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: Chart(_recentTransactions))
            : Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: TransactionList(_userTransaction, _remove)),
      ],
    );
    final pagebody = SafeArea(
      // this safeArea for avoiding any losing of bit in IOS
      // becouse in IOS there is an ome Reserved Area
      child: SingleChildScrollView(
        child: isLandscape
            ? _onlandWidget
            : Column(
                children: <Widget>[
                  Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.3,
                      child: Chart(_recentTransactions)),
                  Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: TransactionList(_userTransaction, _remove)),
                ],
              ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pagebody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pagebody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                //this Exepretion to return empty container if in IOS platform
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddTransaction(context),
                  ),
          );
  }
}
