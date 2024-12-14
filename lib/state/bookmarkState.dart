import 'package:flutter/material.dart';
import 'package:therapistapp/helper/shared_prefrence_helper.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/model/bookmarkModel.dart';
import 'package:therapistapp/model/feedModel.dart';
import 'package:therapistapp/state/appState.dart';
import 'package:therapistapp/ui/page/common/locator.dart';

class BookmarkState extends AppState {
  List<FeedModel>? _tweetList;
  List<FeedModel>? get tweetList => _tweetList;

  List<BookmarkModel>? _bookmarkList;
  List<BookmarkModel>? get bookmarkList => _bookmarkList;

  /// get [Notification list] from firebase realtime database
  void getDataFromDatabase() async {
    String userId = await getIt<SharedPreferenceHelper>()
        .getUserProfile()
        .then((value) => value!.userId!);
    try {
      if (_tweetList != null) {
        return;
      }
      isBusy = true;

      // Simulate fetching data from the database with static sample data
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay

      // Sample data
      var sampleBookmarkData = [
        {
          'key': 'bookmark1',
          'tweetId': 'tweet1',
          'createdAt': DateTime.now().toString(),
        },
        {
          'key': 'bookmark2',
          'tweetId': 'tweet2',
          'createdAt': DateTime.now().toString(),
        },
      ];

      _bookmarkList = sampleBookmarkData.map((data) {
        var model = BookmarkModel.fromJson(data);
        model.key = data['key'] as String;
        addBookmarkTweetToList(model);
        return model;
      }).toList();

      if (_bookmarkList != null) {
        _bookmarkList!.sort((x, y) => DateTime.parse(y.createdAt)
            .compareTo(DateTime.parse(x.createdAt)));
      }

      isBusy = false;
      notifyListeners();
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  void addBookmarkTweetToList(BookmarkModel model) {
    // Simulate adding a tweet to the list
    var tweet = FeedModel(
      key: model.tweetId,
      description: 'Sample tweet description for ${model.tweetId}',
      createdAt: model.createdAt,
      userId: 'sampleUserId', // Add this line
    );
    _tweetList ??= [];
    _tweetList!.add(tweet);
  }

  /// get `Tweet` present in notification
  Future<FeedModel?> getTweetDetail(String tweetId) async {
    // Simulate fetching tweet detail with static sample data
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    // Sample tweet detail
    var sampleTweetDetail = {
      'key': tweetId,
      'description': 'Sample tweet description for $tweetId',
      'createdAt': DateTime.now().toString(),
    };

    var tweetDetail = FeedModel.fromJson(sampleTweetDetail);
    tweetDetail.key = tweetId;
    return tweetDetail;
  }
}