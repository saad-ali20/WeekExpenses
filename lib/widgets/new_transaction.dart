import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//we refactor NewTransaction from stateless to statefuleWidget for avoid losing data
// from flutter re evaluation to our app
class NewTransaction extends StatefulWidget {
  Function addTransaction;
  NewTransaction(this.addTransaction);
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  String titleinput;
  double amountinput;
  DateTime _date = DateTime.now();

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1978),
      lastDate: DateTime(2222),
    );
    if (picker != null && picker != _date) {
      setState(() {
        _date = picker;
      });
    }
  }

  void submitData() {
    if (titleinput.isEmpty || amountinput <= 0) {
      return;
    }
    widget.addTransaction(titleinput, amountinput, _date);
    Navigator.of(context).pop(); // this code for closing the sheet
    //widget and context used her to connect to NewTransaction addTransaction and context
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 10,
            right: 10,
            top: 10,
          ),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'title'),
                onChanged: (val) {
                  titleinput = val;
                },
                onSubmitted: (_) => submitData(),
                //we use this methoud again to add transaction just ont empty field
              ),
              TextField(
                decoration: InputDecoration(labelText: 'amount'),
                onChanged: (val) {
                  amountinput = double.parse(val);
                },
                onSubmitted: (_) => submitData(),
                keyboardType: TextInputType.number,
              ),
              Container(
                height: 37,
                margin: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Text(
                      _date == null
                          ? 'no Date CHosen'
                          : (DateFormat.yMMMd().format(_date)).toString(),
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    FlatButton(
                      child: Text(
                        'chose date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        selectDate(context);
                      },
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('sdd Transaction'),
                onPressed: submitData,
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
