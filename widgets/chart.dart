import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  List<Map<String,dynamic>> recentTransactions = [];

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (DateTime.parse(recentTransactions[i]['raw_date']).day == weekDay.day &&
            DateTime.parse(recentTransactions[i]['raw_date']).month == weekDay.month &&
            DateTime.parse(recentTransactions[i]['raw_date']).year == weekDay.year) {
          totalSum += recentTransactions[i]['price'];
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 17),
          child: Text('Total Expenses in Last 7 Days :    ₹${totalSpending.toInt()}',
          style: TextStyle(
            color: Colors.deepPurple,
          ),
          ),
        ),
        Card(
          elevation: 6,
          margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues.map((data) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalSpending == 0.0
                        ? 0.0
                        : (data['amount'] as double) / totalSpending,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
