import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'char_bar.dart';

class Chart extends StatelessWidget {
  List<Transaction> recentTransaction;
  Chart(this.recentTransaction);
  List<Map<String, Object>> get groupedTransactionsValue {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekday.day &&
            recentTransaction[i].date.month == weekday.month &&
            recentTransaction[i].date.year == weekday.year) {
          totalSum += recentTransaction[i].amount;
        }
      }
      print(DateFormat.E().format(weekday));
      print(totalSum);
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
      //DateFormat.E().format(weekday) formating week days into 3 char name
      // istead of long name substring return 1 char of name
    }).reversed.toList();
  }

  //the fold allow you to return another type from type list
  // 0.0 is initial value for the sum
  //item is the item of the list groupdT
  double get totalSpending {
    return groupedTransactionsValue.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //row shoude gnerated dynamicaly by methoud
          children: groupedTransactionsValue.map((data) {
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalSpending == 0.0
                        ? 0.0
                        : (data['amount'] as double) / totalSpending));
            // if we delete as double we get error on dividing
            // becouse amount not recognizing as double
          }).toList()),
    );
  }
}
