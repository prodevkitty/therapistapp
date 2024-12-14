import 'dart:async';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/model/push_notification_model.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationService {
  PushNotificationService() {
    initializeMessages();
  }

  late PublishSubject<PushNotificationModel> _pushNotificationSubject;

  Stream<PushNotificationModel> get pushNotificationResponseStream =>
      _pushNotificationSubject.stream;

  late StreamSubscription _backgroundMessageSubscription;

  void initializeMessages() {
    _pushNotificationSubject = PublishSubject<PushNotificationModel>();
    _backgroundMessageSubscription = _pushNotificationSubject.stream.listen((message) {
      cprint("Handling a background message: ${message.id}");
    });
  }

  void dispose() {
    _backgroundMessageSubscription.cancel();
    _pushNotificationSubject.close();
  }

  Future<void> simulateIncomingNotification() async {
    // Simulate incoming notification with sample data
    final notification = PushNotificationModel(
      id: "sample_id",
      type: "mention",
      receiverId: "receiver_id",
      senderId: "sender_id",
      title: "Sample Notification",
      body: "This is a sample notification body",
      tweetId: "tweet_id",
    );
    _pushNotificationSubject.add(notification);
  }
}