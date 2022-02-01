import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/screens/home/screen_home.dart';

import 'db/category/category_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Init and register Hive adapters
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  await CategoryDB.instance.refreshUI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
        selectedRowColor: Colors.purple,
        unselectedWidgetColor: Colors.grey,
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const ScreenHome(),
      routes: {
        ScreenAddTransaction.routeName: (ctx) => const ScreenAddTransaction(),
      },
    );
  }
}
