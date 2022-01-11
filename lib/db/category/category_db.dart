import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/category/category_model.dart';

// ignore: constant_identifier_names
const CATEGORY_DB_NAME = 'category_database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDbFunctions {
  //For making the class singleton
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }
  ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    //add object with id specified
    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _categoryDB = await getCategories();

    //Clear current lists
    incomeCategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();

    await Future.forEach<CategoryModel>(_categoryDB, (category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListNotifier.value.add(category);
        incomeCategoryListNotifier.notifyListeners();
      } else {
        expenseCategoryListNotifier.value.add(category);
        expenseCategoryListNotifier.notifyListeners();
      }
    });
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDB.delete(categoryID);
    refreshUI();
  }
}
