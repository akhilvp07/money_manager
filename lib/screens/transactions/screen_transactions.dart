import 'package:flutter/material.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        itemBuilder: (ctx, index) {
          return const Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Text(
                  '12\nDec',
                  textAlign: TextAlign.center,
                ),
              ),
              title: Text('Rs 1999'),
              subtitle: Text('Travel'),
            ),
          );
        },
        separatorBuilder: (ctx, index) {
          return const SizedBox(
            height: 1,
          );
        },
        itemCount: 10);
  }
}
