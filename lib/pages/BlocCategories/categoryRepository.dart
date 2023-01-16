import 'dart:io';

import 'package:irecycle/pages/BlocCategories/addCategory.dart';
import 'package:uuid/uuid.dart';

import 'category.dart';

class CategoryRepository {
  final uuid = const Uuid();
  List<category> categoryList = [];

  List<category> addCategory(String name, String description, File? image) {
    var toAdd = category(name: name, description: description, image: image);
    categoryList.add(toAdd);
    return categoryList;
  }
/*
  List<category> removeTodo(String id) {
    categoryList.removeWhere((element) => element.todoId == id);
    return categoryList;
  }

  List<category> updateTodoState(bool isCompleted, String id) {
    for (category element in categoryList) {
      if (element.todoId == id) {
        element.isCompleted = isCompleted;
      }
    }
    */
  //return categoryList;
}
