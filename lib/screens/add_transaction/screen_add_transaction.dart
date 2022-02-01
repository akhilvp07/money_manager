import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  CategoryType? _selectedCategoryType = CategoryType.expense;
  DateTime? _selectedDate;
  CategoryModel? _selectedCategoryModel;

/*
Fields to be displayed:
  Purpose
  Amount
  Income/Expense
  Date
  Category Type
*/
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
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: 'Purpose', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8.0,
              ),
              //Amount
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Amount', border: OutlineInputBorder()),
              ),

              //Date
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
                          });
                        },
                      ),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),
              //Category type dropdown
              DropdownButton(
                //value: _selectedCategoryModel.name,
                hint: const Text('Select Category'),
                items: CategoryDB.instance.expenseCategoryListNotifier.value
                    .map((e) {
                  return DropdownMenuItem(
                    child: Text(e.name),
                    value: e.id,
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    //_selectedCategoryModel.name = selectedValue;
                  });
                  print(selectedValue);
                },
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
