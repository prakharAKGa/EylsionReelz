
import 'package:eylsion/blocs/video_event.dart';
import 'package:eylsion/blocs/video_state.dart';
import 'package:eylsion/models/video_res.dart';
import 'package:eylsion/repository/video_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final UserRepository _repository = UserRepository();

  FeedBloc() : super(FeedInitialState()) {
    on<GetFeedsEvent>((event, emit) async {
      emit(FeedLoadingState());

      try {
        FeedResponse response = await _repository.getFeeds();
        emit(FeedLoadedState(response));
      } catch (e) {
        emit(FeedErrorState("Failed to load feeds"));
      }
    });
  }
}
