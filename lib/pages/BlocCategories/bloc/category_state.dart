part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  /*
  final List<category> categoryList;
  const CategoryState(List<category> categoryList, {
    this.categoryList = const <category>[],
  });
*/
  const CategoryState();
  @override
  List<Object> get props => [];

  Map<String, dynamic>? toJson() {}
}

/*
class CategoryInitial extends CategoryState {
  Map<String, dynamic> toJson() {
    return {'category': categoryList};
  }
}
*/
class CategoryLoaded extends CategoryState {
  final List<category> categoryList;

  const CategoryLoaded(this.categoryList);

  @override
  List<Object> get props => [categoryList];

  @override
  Map<String, dynamic> toJson() {
    return {'category': categoryList};
  }
}
