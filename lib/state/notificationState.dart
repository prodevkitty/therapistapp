// ignore_for_file: avoid_print

import 'dart:async';

import '../helper/utility.dart';
import '../model/feedModel.dart';
import '../model/notificationModel.dart';
import '../model/user.dart';
import '../resource/push_notification_service.dart';
import '../ui/page/common/locator.dart';
import 'appState.dart';

class NotificationState extends AppState {
  // String fcmToken;
  // FeedModel notificationTweetModel;

  // FcmNotificationModel notification;
  // String notificationSenderId;
  List<NotificationModel>? query;
  List<UserModel> userList = [];

  List<NotificationModel>? _notificationList;

  addNotificationList(NotificationModel model) {
    _notificationList ??= <NotificationModel>[];

    if (!_notificationList!.any((element) => element.id == model.id)) {
      _notificationList!.insert(0, model);
    }
  }

  List<NotificationModel>? get notificationList => _notificationList;

  /// [Intitilise firebase notification kDatabase]
  Future<bool> databaseInit(String userId) async {
    try {
      if (query != null) {
        query = null;
        _notificationList = null;
      }
      // Example static data
      var exampleData = [
        NotificationModel(id: '1', tweetKey: 'tweet1', createdAt: DateTime.now().toIso8601String(), type: 'type1', data: {'content': 'data1'}),
        NotificationModel(id: '2', tweetKey: 'tweet2', createdAt: DateTime.now().subtract(Duration(days: 1)).toIso8601String(), type: 'type2', data: {'content': 'data2'}),
      ];
      for (var model in exampleData) {
        addNotificationList(model);
      }
      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  /// get [Notification list] from firebase realtime database
  void getDataFromDatabase(String userId) {
    try {
      if (_notificationList != null) {
        return;
      }
      isBusy = true;
      // Example static data
      var exampleData = [
        NotificationModel(id: '1', tweetKey: 'tweet1', createdAt: DateTime.now().toIso8601String(), type: 'type1', data: {'content': 'data1'}),
        NotificationModel(id: '2', tweetKey: 'tweet2', createdAt: DateTime.now().subtract(Duration(days: 1)).toIso8601String(), type: 'type2', data: {'content': 'data2'}),
      ];
      for (var model in exampleData) {
        addNotificationList(model);
      }
      _notificationList!.sort((x, y) => x.timeStamp!.compareTo(y.timeStamp!));
      isBusy = false;
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  /// get `Tweet` present in notification
  Future<FeedModel?> getTweetDetail(String tweetId) async {
    // Example static data
    var exampleData = {
      'tweet1': {'id': '1', 'content': 'This is a tweet', 'createdAt': DateTime.now().toIso8601String()},
      'tweet2': {'id': '2', 'content': 'This is another tweet', 'createdAt': DateTime.now().subtract(Duration(days: 1)).toIso8601String()},
    };

    if (exampleData.containsKey(tweetId)) {
      var map = exampleData[tweetId]!;
      var _tweetDetail = FeedModel.fromJson(map);
      _tweetDetail.key = tweetId;
      return _tweetDetail;
    } else {
      return null;
    }
  }

  /// get user who liked your tweet
  Future<UserModel?> getUserDetail(String userId) async {
    UserModel user;
    if (userList.isNotEmpty && userList.any((x) => x.userId == userId)) {
      return Future.value(userList.firstWhere((x) => x.userId == userId));
    }
    // Example static data
    var exampleData = {
      'user1': {'userId': '1', 'name': 'John Doe', 'profilePic': 'url1'},
      'user2': {'userId': '2', 'name': 'Jane Doe', 'profilePic': 'url2'},
    };

    if (exampleData.containsKey(userId)) {
      var map = exampleData[userId]!;
      user = UserModel.fromJson(map);
      user.key = userId;
      userList.add(user);
      return user;
    } else {
      return null;
    }
  }

  /// Remove notification if related Tweet is not found or deleted
  void removeNotification(String userId, String tweetkey) async {
    _notificationList?.removeWhere((notification) => notification.tweetKey == tweetkey);
    print("Notification removed for user: $userId, tweet: $tweetkey");
  }

  /// Trigger when somneone like your tweet
  // Removed _onNotificationAdded method as it is not used and DatabaseEvent is undefined

  /// Trigger when someone changed his like preference
  // Removed _onNotificationChanged method as it is not used and DatabaseEvent is undefined

  /// Trigger when someone undo his like on tweet
  // Removed _onNotificationRemoved method as it is not used and DatabaseEvent is undefined

  /// Initilise push notification services
  void initFirebaseService() {
    if (!getIt.isRegistered<PushNotificationService>()) {
      getIt.registerSingleton<PushNotificationService>(
          PushNotificationService());
    }
  }

  @override
  void dispose() {
    getIt.unregister<PushNotificationService>();
    super.dispose();
  }
}
