import 'package:eylsion/models/video_res.dart';

abstract class FeedState {}

class FeedInitialState extends FeedState {}

class FeedLoadingState extends FeedState {}

class FeedLoadedState extends FeedState {
  final FeedResponse feedResponse;
  FeedLoadedState(this.feedResponse);
}

class FeedErrorState extends FeedState {
  final String message;
  FeedErrorState(this.message);
}
