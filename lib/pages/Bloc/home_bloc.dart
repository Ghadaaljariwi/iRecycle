import 'dart:math';

import 'package:irecycle/pages/Bloc/Post.dart';
import 'package:irecycle/pages/Bloc/home_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irecycle/pages/Bloc/home_state.dart';
import 'package:irecycle/pages/Bloc/post_generator.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitialState()) {
    on<FetchDataEvent>(_onFetchDataEvent);
  }

  void _onFetchDataEvent(
    FetchDataEvent event,
    Emitter<HomeState> emitter,
  ) async {
    emitter(const HomeLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    bool isSucceed = Random().nextBool();
    if (isSucceed) {
      List<Post> _dummyFoods = PostGenerator.generateDummyPosts();
      emitter(HomeSuccessFetchDataState(posts: _dummyFoods));
    } else {
      emitter(const HomeErrorFetchDataState(
        errorMessage: "something went very wrong :(",
      ));
    }
  }
}
