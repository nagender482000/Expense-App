import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Model/transaction.dart';
import './Widgets/transaction_list.dart';
import './Widgets/new_transaction.dart';
import './Widgets/chart.dart';
import 'dart:io';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Perfume',
    //   amount: 239.0,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't1',
    //   title: 'New Perfume',
    //   amount: 239.0,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showchart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime choosendate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: choosendate,
      id: DateTime.now().toString(),
    );

    setState(
      () {
        _userTransaction.add(newTx);
      },
    );
  }

  // ignore: non_constant_identifier_names
  void _StartAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _StartAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            leading: BackButton(),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _StartAddNewTransaction(context),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            title: Center(
              child: Text("Expense App"),
            ),
          );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (islandscape)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Show Chart',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Switch.adaptive(
                              activeColor: Theme.of(context).accentColor,
                              value: _showchart,
                              onChanged: (val) {
                                setState(() {
                                  _showchart = val;
                                });
                              }),
                        ],
                      ),

                    //For Potrait Mode
                    if (!islandscape)
                      Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.3,
                        child: Chart(_recentTransactions),
                      ),
                    if (!islandscape)
                      Container(
                          height: (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.7,
                          child: TranscationList(
                              _userTransaction, _deleteTransaction)),

                    //For Landscape mode
                    if (islandscape)
                      _showchart
                          ? Container(
                              height: (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.7,
                              child: Chart(_recentTransactions),
                            )
                          : Container(
                              height: (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.7,
                              child: TranscationList(
                                  _userTransaction, _deleteTransaction)),
                  ],
                ),
              ),
            ),
          )

        //Android Body
        : Scaffold(
            appBar: appBar,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (islandscape)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Show Chart'),
                          Switch.adaptive(
                              activeColor: Theme.of(context).accentColor,
                              value: _showchart,
                              onChanged: (val) {
                                setState(() {
                                  _showchart = val;
                                });
                              }),
                        ],
                      ),

                    //For Potrait Mode
                    if (!islandscape)
                      Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.3,
                        child: Chart(_recentTransactions),
                      ),
                    if (!islandscape)
                      Container(
                          height: (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.7,
                          child: TranscationList(
                              _userTransaction, _deleteTransaction)),

                    //For Landscape mode
                    if (islandscape)
                      _showchart
                          ? Container(
                              height: (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.7,
                              child: Chart(_recentTransactions),
                            )
                          : Container(
                              height: (MediaQuery.of(context).size.height -
                                      appBar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.7,
                              child: TranscationList(
                                  _userTransaction, _deleteTransaction)),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _StartAddNewTransaction(context),
                  ),
          );
  }
}
