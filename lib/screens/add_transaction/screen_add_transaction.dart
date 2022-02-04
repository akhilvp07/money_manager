import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  CategoryType? _selectedCategoryType;
  DateTime? _selectedDate;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;
  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

/*
Fields to be displayed:
  Purpose
  Amount
  Income/Expense
  Date
  Category Type
*/
  @override
  void initState() {
    _selectedCategoryType = CategoryType.expense;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Transaction'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Purpose
              TextFormField(
                controller: _purposeTextEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: 'Purpose', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8.0,
              ),
              //Amount
              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Amount', border: OutlineInputBorder()),
              ),

              //Date selection
              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDate == null
                    ? 'Select date'
                    : _selectedDate.toString()),
              ),
              //Income or Expense
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (CategoryType? newValue) {
                          setState(() {
                            _selectedCategoryType = newValue;
                            _categoryID = null;
                          });
                        },
                      ),
                      const Text('Income'),
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (CategoryType? newValue) {
                          setState(() {
                            _selectedCategoryType = newValue;
                            _categoryID = null;
                          });
                        },
                      ),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),
              //Category type dropdown
              DropdownButton<String>(
                value: _categoryID,
                hint: const Text('Select Category'),
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDB.instance.incomeCategoryListNotifier
                        : CategoryDB.instance.expenseCategoryListNotifier)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    child: Text(e.name),
                    value: e.id,
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    _categoryID = selectedValue;
                  });
                  print(selectedValue);
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  addTransaction();
                  // TransactionDb.instance.getTransactons().then((value) {
                  //   print(value);
                  // });
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeTxt = _purposeTextEditingController.text;
    final _amountTxt = _amountTextEditingController.text;

    if (_purposeTxt.isEmpty) {
      return;
    }
    if (_amountTxt.isEmpty) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    //_selectedDate
    //_selectedCategoryType
    //_categoryID

    final _parsedAmount = double.tryParse(_amountTxt);
    if (_parsedAmount == null) {
      return;
    }

    TransactionModel transaction = TransactionModel(
      purpose: _purposeTxt,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.insertTransaction(transaction);
    Navigator.of(context).pop();
    TransactionDB.instance.refreshTransactions();
  }
}
