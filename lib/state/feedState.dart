import 'dart:async';
import 'dart:io';
import 'package:therapistapp/helper/enum.dart';
import 'package:therapistapp/helper/shared_prefrence_helper.dart';
import 'package:therapistapp/model/feedModel.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/model/user.dart';
import 'package:therapistapp/state/appState.dart';
import 'package:therapistapp/ui/page/common/locator.dart';
// import 'package:link_preview_generator/link_preview_generator.dart'
//     show WebInfo;
import 'package:path/path.dart' as path;
import 'package:translator/translator.dart';

class FeedState extends AppState {
  bool isBusy = false;
  Map<String, List<FeedModel>?>? tweetReplyMap = {};
  FeedModel? _tweetToReplyModel;
  FeedModel? get tweetToReplyModel => _tweetToReplyModel;
  set setTweetToReply(FeedModel model) {
    _tweetToReplyModel = model;
  }

  late List<FeedModel> _commentList;

  List<FeedModel>? _feedList;
  List<FeedModel>? _feedQuery;
  List<FeedModel>? _tweetDetailModelList;

  List<FeedModel>? get tweetDetailModel => _tweetDetailModelList;

  /// `feedList` always [contain all tweets] fetched from firebase database
  List<FeedModel>? get feedList {
    if (_feedList == null) {
      return null;
    } else {
      return List.from(_feedList!.reversed);
    }
  }

  /// contain tweet list for home page
  List<FeedModel>? getTweetList(UserModel? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedList != null && feedList!.isNotEmpty) {
      list = feedList!.where((x) {
        /// If Tweet is a comment then no need to add it in tweet list
        if (x.parentkey != null &&
            x.childRetwetkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Tweets of logged-in user's and his following user's
        // if (x.user!.userId == userModel.userId ||
        //     (userModel.followingList != null &&
        //         userModel.followingList!.contains(x.user!.userId))) {
        //   return true;
        // } else {
        //   return false;
        // }
        return true;
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  Map<String, dynamic> _linkWebInfos = {};
  Map<String, dynamic> get linkWebInfos => _linkWebInfos;
  void addWebInfo(String url, dynamic webInfo) {
    _linkWebInfos.addAll({url: webInfo});
  }

  Map<String, Translation?> _tweetsTranslations = {};
  Map<String, Translation?> get tweetsTranslations => _tweetsTranslations;
  void addTweetTranslation(String tweet, Translation? translation) {
    _tweetsTranslations.addAll({tweet: translation});
    notifyListeners();
  }

  /// set tweet for detail tweet page
  /// Setter call when tweet is tapped to view detail
  /// Add Tweet detail is added in _tweetDetailModelList
  /// It makes `Fwitter` to view nested Tweets
  set setFeedModel(FeedModel model) {
    _tweetDetailModelList ??= [];

    /// [Skip if any duplicate tweet already present]

    _tweetDetailModelList!.add(model);
    cprint("Detail Tweet added. Total Tweet: ${_tweetDetailModelList!.length}");
    notifyListeners();
  }

  /// `remove` last Tweet from tweet detail page stack
  /// Function called when navigating back from a Tweet detail
  /// `_tweetDetailModelList` is map which contain lists of comment Tweet list
  /// After removing Tweet from Tweet detail Page stack its comments tweet is also removed from `_tweetDetailModelList`
  void removeLastTweetDetail(String tweetKey) {
    if (_tweetDetailModelList != null && _tweetDetailModelList!.isNotEmpty) {
      // var index = _tweetDetailModelList.in
      FeedModel removeTweet =
          _tweetDetailModelList!.lastWhere((x) => x.key == tweetKey);
      _tweetDetailModelList!.remove(removeTweet);
      tweetReplyMap?.removeWhere((key, value) => key == tweetKey);
      cprint(
          "Last index Tweet removed from list. Remaining Tweet: ${_tweetDetailModelList!.length}");
      notifyListeners();
    }
  }

  /// [clear all tweets] if any tweet present in tweet detail page or comment tweet
  void clearAllDetailAndReplyTweetStack() {
    if (_tweetDetailModelList != null) {
      _tweetDetailModelList!.clear();
    }
    if (tweetReplyMap != null) {
      tweetReplyMap!.clear();
    }
    cprint('Empty tweets from stack');
  }

  /// [Subscribe Tweets] firebase Database
  Future<bool> databaseInit() {
    try {
      if (_feedList == null) {
        _feedList = <FeedModel>[];
        // Add initial data or perform any setup needed
      }

      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  /// get [Tweet list] from firebase realtime database
  void getDataFromDatabase() {
    try {
      isBusy = true;
      _feedList = null;
      notifyListeners();
      _feedList = <FeedModel>[
        FeedModel(
          key: '1',
          description: 'This is a static tweet example 1',
          createdAt: DateTime.now().toIso8601String(),
          userId: 'user1',
        ),
        FeedModel(
          key: '2',
          description: 'This is a static tweet example 2',
          createdAt: DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
          userId: 'user2',
        ),
      ];
      isBusy = false;
      notifyListeners();
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  /// get [Tweet Detail] from firebase realtime kDatabase
  /// If model is null then fetch tweet from firebase
  /// [getPostDetailFromDatabase] is used to set prepare Tweet to display Tweet detail
  /// After getting tweet detail fetch tweet comments from firebase
  void getPostDetailFromDatabase(String? postID, {FeedModel? model}) async {
    try {
      FeedModel? _tweetDetail;
      if (model != null) {
        // set tweet data from tweet list data.
        // No need to fetch tweet from firebase db if data already present in tweet list
        _tweetDetail = model;
        setFeedModel = _tweetDetail;
        postID = model.key;
      } else {
        assert(postID != null);
        // Fetch tweet data from firebase
        // Simulate fetching tweet data without Firebase
        var staticData = {
          '1': {
            'key': '1',
            'description': 'This is a static tweet example 1',
            'createdAt': DateTime.now().toIso8601String(),
            'userId': 'user1',
          },
          '2': {
            'key': '2',
            'description': 'This is a static tweet example 2',
            'createdAt': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
            'userId': 'user2',
          },
        };

        if (staticData.containsKey(postID)) {
          var map = staticData[postID]!;
          _tweetDetail = FeedModel.fromJson(map);
          _tweetDetail!.key = postID;
          setFeedModel = _tweetDetail!;
        }
      }

      if (_tweetDetail != null) {
        // Fetch comment tweets
        _commentList = <FeedModel>[];
        // Check if parent tweet has reply tweets or not
        if (_tweetDetail!.replyTweetKeyList != null &&
            _tweetDetail!.replyTweetKeyList!.isNotEmpty) {
          for (String? x in _tweetDetail!.replyTweetKeyList!) {
            if (x == null) {
              return;
            }
            var staticComments = {
              '1': {
                'key': '1',
                'description': 'This is a static comment example 1',
                'createdAt': DateTime.now().toIso8601String(),
                'userId': 'user1',
              },
              '2': {
                'key': '2',
                'description': 'This is a static comment example 2',
                'createdAt': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
                'userId': 'user2',
              },
            };

            if (staticComments.containsKey(x)) {
              var map = staticComments[x]!;
              var commentModel = FeedModel.fromJson(map);
              String key = x!;
              commentModel.key = key;

              /// add comment tweet to list if tweet is not present in [comment tweet ]list
              /// To reduce delicacy
              if (!_commentList.any((x) => x.key == key)) {
                _commentList.add(commentModel);
              }
            }

            if (x == _tweetDetail!.replyTweetKeyList!.last) {
              /// Sort comment by time
              /// It helps to display newest Tweet first.
              _commentList.sort((x, y) => DateTime.parse(y.createdAt)
                  .compareTo(DateTime.parse(x.createdAt)));
              tweetReplyMap!.putIfAbsent(postID!, () => _commentList);
              notifyListeners();
            }
          }
        } else {
          tweetReplyMap!.putIfAbsent(postID!, () => _commentList);
          notifyListeners();
        }
      }
    } catch (error) {
      cprint(error, errorIn: 'getPostDetailFromDatabase');
    }
  }

  /// Fetch `Retweet` model from firebase realtime kDatabase.
  /// Retweet itself  is a type of `Tweet`
  Future<FeedModel?> fetchTweet(String postID) async {
    FeedModel? _tweetDetail;

    /// If tweet is available in feedList then no need to fetch it from static data
    if (feedList!.any((x) => x.key == postID)) {
      _tweetDetail = feedList!.firstWhere((x) => x.key == postID);
    }

    /// If tweet is not available in feedList then fetch it from static data
    else {
      cprint("Fetched from static data: " + postID);
      var staticData = {
        '1': {
          'key': '1',
          'description': 'This is a static tweet example 1',
          'createdAt': DateTime.now().toIso8601String(),
          'userId': 'user1',
        },
        '2': {
          'key': '2',
          'description': 'This is a static tweet example 2',
          'createdAt': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
          'userId': 'user2',
        },
      };

      if (staticData.containsKey(postID)) {
        var map = staticData[postID]!;
        _tweetDetail = FeedModel.fromJson(map);
        _tweetDetail!.key = postID;
        print(_tweetDetail!.description);
      } else {
        cprint("Fetched null value from static data");
      }
    }
    return _tweetDetail;
  }

  /// create [New Tweet]
  /// returns Tweet key
  Future<String?> createTweet(FeedModel model) async {
    ///  Create tweet in static data
    isBusy = true;
    notifyListeners();
    String? tweetKey;
    try {
      // Simulate creating a tweet with static data
      tweetKey = DateTime.now().millisecondsSinceEpoch.toString();
      model.key = tweetKey;
      _feedList?.add(model);
    } catch (error) {
      cprint(error, errorIn: 'createTweet');
    }
    isBusy = false;
    notifyListeners();
    return tweetKey;
  }

  ///  It will create tweet in [Firebase kDatabase] just like other normal tweet.
  ///  update retweet count for retweet model
  Future<String?> createReTweet(FeedModel model) async {
    String? tweetKey;
    try {
      tweetKey = await createTweet(model);
      if (_tweetToReplyModel != null) {
        if (_tweetToReplyModel!.retweetCount == null) {
          _tweetToReplyModel!.retweetCount = 0;
        }
        _tweetToReplyModel!.retweetCount =
            _tweetToReplyModel!.retweetCount! + 1;
        updateTweet(_tweetToReplyModel!);
      }
    } catch (error) {
      cprint(error, errorIn: 'createReTweet');
    }
    return tweetKey;
  }

  /// [Delete tweet] in Firebase kDatabase
  /// Remove Tweet if present in home page Tweet list
  /// Remove Tweet if present in Tweet detail page or in comment
  deleteTweet(String tweetId, TweetType type, {String? parentkey}) {
    try {
      /// Delete tweet if it is in nested tweet detail page
      var tweetIndex = _feedList?.indexWhere((tweet) => tweet.key == tweetId);
      if (tweetIndex != null && tweetIndex != -1) {
        _feedList?.removeAt(tweetIndex);
        if (type == TweetType.Detail &&
            _tweetDetailModelList != null &&
            _tweetDetailModelList!.isNotEmpty) {
          _tweetDetailModelList!.removeWhere((tweet) => tweet.key == tweetId);
          if (_tweetDetailModelList!.isEmpty) {
            _tweetDetailModelList = null;
          }
          cprint('Tweet deleted from nested tweet detail page tweet');
        }
      }
      notifyListeners();
    } catch (error) {
      cprint(error, errorIn: 'deleteTweet');
    }
  }

  /// upload [file] to firebase storage and return its  path url
  Future<String?> uploadFile(File file) async {
    try {
      isBusy = true;
      notifyListeners();
      // Simulate file upload and return a static URL
      await Future.delayed(Duration(seconds: 2)); // Simulate delay
      var url = 'https://example.com/static/${path.basename(file.path)}';
      return url;
    } catch (error) {
      cprint(error, errorIn: 'uploadFile');
      return null;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  /// [Delete file] from firebase storage
  Future<void> deleteFile(String url, String baseUrl) async {
    try {
      var filePath = url.split(".com/o/")[1];
      filePath = filePath.replaceAll(RegExp(r'%2F'), '/');
      filePath = filePath.replaceAll(RegExp(r'(\?alt).*'), '');
      //  filePath = filePath.replaceAll('tweetImage/', '');
      cprint('[Path]' + filePath);
      // Simulate file deletion
      await Future.delayed(Duration(seconds: 1)); // Simulate delay
      cprint('[Success] Image deleted');
    } catch (error) {
      cprint(error, errorIn: 'deleteFile');
    }
  }

  /// [update] tweet
  Future<void> updateTweet(FeedModel model) async {
    try {
      // Simulate updating a tweet in static data
      var index = _feedList?.indexWhere((tweet) => tweet.key == model.key);
      if (index != null && index != -1) {
        _feedList?[index] = model;
      }
      cprint('Tweet updated successfully');
    } catch (error) {
      cprint(error, errorIn: 'updateTweet');
    }
  }

  /// Add/Remove like on a Tweet
  /// [postId] is tweet id, [userId] is user's id who like/unlike Tweet
  addLikeToTweet(FeedModel tweet, String userId) {
    try {
      if (tweet.likeList != null &&
          tweet.likeList!.isNotEmpty &&
          tweet.likeList!.any((id) => id == userId)) {
        // If user wants to undo/remove his like on tweet
        tweet.likeList!.removeWhere((id) => id == userId);
        tweet.likeCount = tweet.likeCount! - 1;
      } else {
        // If user like Tweet
        tweet.likeList ??= [];
        tweet.likeList!.add(userId);
        tweet.likeCount = tweet.likeCount! + 1;
      }
      // Simulate updating likeList in static data
      var tweetIndex = _feedList?.indexWhere((t) => t.key == tweet.key);
      if (tweetIndex != null && tweetIndex != -1) {
        _feedList?[tweetIndex] = tweet;
      }
    } catch (error) {
      cprint(error, errorIn: 'addLikeToTweet');
    }
  }

  /// Add [new comment tweet] to any tweet
  /// Comment is a Tweet itself
  Future<String?> addCommentToPost(FeedModel replyTweet) async {
    try {
      isBusy = true;
      notifyListeners();
      // String tweetKey;
      if (_tweetToReplyModel != null) {
        FeedModel tweet =
            _feedList!.firstWhere((x) => x.key == _tweetToReplyModel!.key);
        String commentKey = DateTime.now().millisecondsSinceEpoch.toString();
        replyTweet.key = commentKey;
        tweet.replyTweetKeyList!.add(commentKey);
        _feedList?.add(replyTweet);
        await updateTweet(tweet);
        return commentKey;
      } else {
        return null;
      }
    } catch (error) {
      cprint(error, errorIn: 'addCommentToPost');
      return null;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  /// Add Tweet in bookmark
  Future addBookmark(String tweetId) async {
    final pref = getIt<SharedPreferenceHelper>();
    var userId = await pref.getUserProfile().then((value) => value!.userId);
    // Simulate adding a bookmark to static data
    var bookmarks = <String, Map<String, String>>{};
    bookmarks[tweetId] = {
      "tweetId": tweetId,
      "created_at": DateTime.now().toUtc().toString()
    };
    cprint('Bookmark added: $bookmarks');
  }
}
