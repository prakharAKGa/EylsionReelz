import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eylsion/blocs/video_bloc.dart';
import 'package:eylsion/blocs/video_event.dart';
import 'package:eylsion/blocs/video_state.dart';
import 'package:eylsion/models/video_model.dart';
import 'package:eylsion/models/video_res.dart';
import 'package:eylsion/widgets/comments.dart';
import 'package:eylsion/widgets/error.dart';
import 'package:eylsion/widgets/load.dart';
import 'package:eylsion/widgets/video_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLiked = false;
  late PageController _pageController;

  bool _isOffline = false; 

  void _toggleHeart() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkNetworkStatus(); 
    context.read<FeedBloc>().add(GetFeedsEvent());
  }

Future<void> _checkNetworkStatus() async {
  List<ConnectivityResult> results = await Connectivity().checkConnectivity(); 
  if (results.contains(ConnectivityResult.none)) {
    setState(() {
      _isOffline = true;
    });
  } else {
    setState(() {
      _isOffline = false;
    });
  }
}



  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isOffline
          ? buildErrorWidget("No internet connection")
          : BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedLoadingState) {
                  return buildLoadingWidget();
                } else if (state is FeedLoadedState) {
                  return _buildFeedWidget(state.feedResponse);
                } else if (state is FeedErrorState) {
                  return buildErrorWidget(state.message);
                } else {
                  return buildErrorWidget("Unexpected error");
                }
              },
            ),
    );
  }

  Widget _buildFeedWidget(FeedResponse data) {
    List<FeedModel> feeds = data.feeds;
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              VideoWidget(url: feeds[index].videos[0].link),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.15),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0, 0.6, 1],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 32,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.white),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(feeds[index].image),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            feeds[index].user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white, 
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: Colors.transparent,
                              elevation: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                    horizontal: 1.0), 
                                child: const Text(
                                  "Follow",
                                  style: TextStyle(
                                    fontSize: 14, 
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        feeds[index].user.url,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 50,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: _toggleHeart,
                      icon: Icon(
                        _isLiked ? Ionicons.heart : Ionicons.heart_outline,
                        color: _isLiked ? Colors.red : Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CommentsButtonWidget(
                      onPressed: () {
                        _showCommentsSheet(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Ionicons.paper_plane_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Ionicons.ellipsis_vertical,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.white),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: const Icon(Ionicons.musical_notes_sharp, size: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: const CommentsSheetWidget(
            comments: [
              {
                'userName': 'User1',
                'comment': 'This is amazing!',
              },
              {
                'userName': 'User2',
                'comment': 'I love this reel!',
              },
            ],
          ),
        );
      },
    );
  }



}
