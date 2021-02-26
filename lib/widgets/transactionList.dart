import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransaction;
  Function remove;
  TransactionList(this._userTransaction, this.remove);
  @override
  Widget build(BuildContext context) {
    return _userTransaction.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constrain) {
              return Column(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'images/empty.jpg',
                      fit: BoxFit.cover,
                    ),
                    height: constrain.maxHeight * 0.6,
                  ),
                  Text(
                    'No Transaction Added',
                    style: Theme.of(context).textTheme.title,
                  )
                ],
              );
            },
          )
        : ListView(
            children: _userTransaction.map((tx) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text('\$${tx.amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    '${tx.title}',
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    DateFormat().add_yMMMd().format(tx.date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 450
                      ? FlatButton.icon(
                          icon: Icon(Icons.delete),
                          textColor: Theme.of(context).primaryColor,
                          label: Text('delete'),
                          onPressed: () {
                            remove(tx);
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            remove(tx);
                          },
                        ),
                ),
              );
            }).toList(),
          );
  }
}
