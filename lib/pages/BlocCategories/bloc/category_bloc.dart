import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../category.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryState()) {
    on<AddCategory>(onAddCategory);
  }

  Future onAddCategory(AddCategory event, Emitter<CategoryState> emit) async {
    final state = this.state;
    QuerySnapshot snapshot = (await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('name')
        .get());

    List<category> _list = [];

    snapshot.docs.forEach((document) {
      category obj = category.fromMap(document.data() as Map<String, dynamic>);
      _list.add(obj);
    });

    emit(CategoryState(
      categoryList: List.from(_list)..add(event.object),
    ));

    //emit(CategoryState(categoryList: _list));
  }

/*
  Future addCategoryDB(String name, String descriprion, File? image) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('categories').doc(cid).set({
      'name': name,
      'descriprion': descriprion,
      'image': image!.path,
      'cid': cid,
    });
  }
*/
  Future _getUserDetail() async {
    QuerySnapshot snapshot = (await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('name')
        .get());

    List<category> _list = [];

    snapshot.docs.forEach((document) {
      category obj = category.fromMap(document.data() as Map<String, dynamic>);
      _list.add(obj);
    });

    (CategoryState(categoryList: _list));
  }

  //void onDeleteCategory(deleteCategory event, Emitter<CategoryState> emit) {}
}
