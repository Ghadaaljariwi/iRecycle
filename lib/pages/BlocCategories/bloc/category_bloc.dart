import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:irecycle/pages/BlocCategories/categoryRepository.dart';

import '../category.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState>
    with HydratedMixin {
  late final CategoryRepository repository;
  CategoryBloc(repository) : super(CategoryState()) {
    on<AddCategory>(onAddCategory);
  }

  void onAddCategory(AddCategory event, Emitter<CategoryState> emit) {
    final state = this.state;
    emit(CategoryState(
      categoryList: List.from(state.categoryList)..add(event.object),
    ));
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    try {
      final listOfCategories = (json['category'] as List)
          .map((e) => category.fromJson(e as Map<String, dynamic>))
          .toList();

      repository.categoryList =
          listOfCategories; //<-- This is IMPORTANT. You must assign the todoList defined in the TodoRepository to the locally stored `listOfTodo` to keep it up to date.
      return CategoryState();
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CategoryState state) {
    // TODO: implement toJson
    //throw UnimplementedError();
    if (state is CategoryState) {
      return state.toJson();
    } else {
      return null;
    }
  }

  //void onDeleteCategory(deleteCategory event, Emitter<CategoryState> emit) {}
}
