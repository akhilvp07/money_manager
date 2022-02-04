import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

// ignore: constant_identifier_names
const TRANSACTON_DB_NAME = 'transaction_database';

abstract class TransactionDbFunctions {
  Future<void> insertTransaction(TransactionModel trasnaction);
  Future<void> deleteTransaction(String id);
  Future<List<TransactionModel>> getTransactons();
  Future<void> refreshTransactions();
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionsListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertTransaction(TransactionModel transaction) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTON_DB_NAME);
    await _db.put(transaction.id, transaction);
  }

  @override
  Future<List<TransactionModel>> getTransactons() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTON_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> refreshTransactions() async {
    final _transactionsList = await getTransactons();

    _transactionsList
        .sort((first, second) => second.date.compareTo(first.date));
    transactionsListNotifier.value.clear();
    transactionsListNotifier.value.addAll(_transactionsList);
    transactionsListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTON_DB_NAME);
    await _db.delete(id);
    await refreshTransactions();
  }
}
