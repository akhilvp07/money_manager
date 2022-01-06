import 'package:flutter/material.dart';
import 'package:money_manager/models/category/category_model.dart';

ValueNotifier<CategoryType> _currentSelectionNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: const [
              RadioButton(title: 'Income', type: CategoryType.income),
              RadioButton(title: 'Expense', type: CategoryType.expense),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () {}, child: const Text('Save')),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: _currentSelectionNotifier,
          builder: (BuildContext ctx, CategoryType newType, _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newType,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                _currentSelectionNotifier.value = value;
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
