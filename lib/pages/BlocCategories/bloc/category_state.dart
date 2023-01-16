part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final List<category> categoryList;
  const CategoryState({
    this.categoryList = const <category>[],
  });

  @override
  List<Object> get props => [categoryList];

  Map<String, dynamic>? toJson() {}
}

class CategoryInitial extends CategoryState {
  Map<String, dynamic> toJson() {
    return {'category': categoryList};
  }
}

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
