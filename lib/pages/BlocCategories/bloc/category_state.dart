part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final List<category> categoryList;
  const CategoryState({
    this.categoryList = const <category>[],
  });

  @override
  List<Object> get props => [categoryList];
}

class CategoryInitial extends CategoryState {}
