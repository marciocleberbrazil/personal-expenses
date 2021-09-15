import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> currentWeekTransactions;

  Chart(this.currentWeekTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    const amountOfDays = 7;

    return List.generate(amountOfDays, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalSum = 0.0;

      for (var item in currentWeekTransactions) {
        if (item.date.day == weekDay.day && item.date.month == weekDay.month && item.date.year == weekDay.year) {
          totalSum += item.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpendings {
    return groupedTransactionValues.fold(0.0, (previousValue, item) {
      return previousValue + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: groupedTransactionValues
                .map(
                  (data) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      day: data['day'],
                      amount: data['amount'],
                      percentage: totalSpendings == 0.0 ? 0.0 : (data['amount'] as double) / totalSpendings,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
