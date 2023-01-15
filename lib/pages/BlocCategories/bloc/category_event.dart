part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [category];
}

class AddCategory extends CategoryEvent {
  final category object;
  const AddCategory({
    required this.object,
  });

  @override
  List<Object> get props => [category];
}
/*
class deleteCategory extends CategoryEvent {
  final category object;
  const deleteCategory({
    required this.object,
  });

  @override
  List<Object> get props => [category];
}
*/