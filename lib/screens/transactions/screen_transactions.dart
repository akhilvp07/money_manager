import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refreshTransactions();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionsListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          itemBuilder: (ctx, index) {
            final _transaction = newList[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Text(
                    parseDate(_transaction.date),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: _transaction.type == CategoryType.income
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text('₹ ${_transaction.amount.toString()}'),
                subtitle: Text(_transaction.purpose),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    TransactionDb.instance.deleteTransaction(_transaction.id!);
                  },
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 1,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n${_splitDate.first}';
  }
}
