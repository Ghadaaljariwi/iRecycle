import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../category.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryState()) {
    on<AddCategory>(onAddCategory);
  }

  void onAddCategory(AddCategory event, Emitter<CategoryState> emit) {
    final state = this.state;
    emit(CategoryState(
      categoryList: List.from(state.categoryList)..add(event.object),
    ));
  }

  //void onDeleteCategory(deleteCategory event, Emitter<CategoryState> emit) {}
}
