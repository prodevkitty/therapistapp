import 'dart:async';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:therapistapp/helper/enum.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/model/push_notification_model.dart';
import 'package:therapistapp/state/appState.dart';
import 'package:therapistapp/state/authState.dart';
import 'package:therapistapp/state/chats/chatState.dart';
import 'package:therapistapp/state/feedState.dart';
import 'package:therapistapp/state/notificationState.dart';
import 'package:therapistapp/ui/page/Auth/signin.dart';
import 'package:therapistapp/ui/page/feed/feedPage.dart';
import 'package:therapistapp/ui/page/feed/feedPostDetail.dart';
import 'package:therapistapp/ui/page/profile/profilePage.dart';
import 'package:therapistapp/widgets/bottomMenuBar/bottomMenuBar.dart';
import 'package:provider/provider.dart';

import 'common/sidebar.dart';
import 'notification/notificationPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int pageIndex = 0;
  // ignore: cancel_subscription
  // late StreamSubscription<PushNotificationModel> pushNotificationSubscription;
  @override
  void initState() {
    // initDynamicLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AppState>(context, listen: false);
      state.setPageIndex = 0;
      initTweets();
      initProfile();
      initNotification();
      initChat();
    });

    super.initState();
  }

  @override
  void dispose() {
    // pushNotificationSubscription.cancel();
    super.dispose();
  }

  void initTweets() {
    var state = Provider.of<FeedState>(context, listen: false);
    state.databaseInit();
    state.getDataFromDatabase();
  }

  void initProfile() {
    // Initialize profile-related data if needed
  }


  void initNotification() {
    var state = Provider.of<NotificationState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    if (authState.userId == null) {
      // Redirect to login page if user is not authenticated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
      return;
    }
    state.databaseInit(authState.userId);

    // Configure push notifications
    // state.initFirebaseService();

    // Subscribe to push notifications
    // pushNotificationSubscription = getIt<PushNotificationService>()
        // .pushNotificationResponseStream
        // .listen(listenPushNotification);
  }

  void listenPushNotification(PushNotificationModel model) {
    final authState = Provider.of<AuthState>(context, listen: false);
    var state = Provider.of<NotificationState>(context, listen: false);

    if (model.type == NotificationType.Message.toString() ) {
      /// Get sender profile detail from firebase
      state.getUserDetail(model.senderId).then((user) {
        Navigator.pushNamed(context, '/ChatScreenPage');
      });
    }
    else if (model.type == NotificationType.Mention.toString()) {
      var feedState = Provider.of<FeedState>(context, listen: false);
      feedState.getPostDetailFromDatabase(model.tweetId);
      Navigator.push(context, FeedPostDetail.getRoute(model.tweetId));
    }
  }

  void initChat() {
    final state = Provider.of<AuthState>(context, listen: false);
    // chatState.databaseInit(state.userId, state.userId);

    /// It will update fcm token in database
    /// fcm token is required to send firebase notification

    /// It get fcm server key
    /// Server key is required to configure firebase notification
    /// Without fcm server notification can not be sent
    // chatState.getFCMServerKey();
  }

  /// Initialize the firebase dynamic link sdk
  // void initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink.listen(
  //       (PendingDynamicLinkData? dynamicLink) async {
  //     final Uri? deepLink = dynamicLink?.link;

  //     if (deepLink != null) {
  //       redirectFromDeepLink(deepLink);
  //     }
  //   }, onError: (e) async {
  //     cprint(e.message, errorIn: "onLinkError");
  //   });

  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri? deepLink = data?.link;

  //   if (deepLink != null) {
  //     redirectFromDeepLink(deepLink);
  //   }
  // }

  /// Redirect user to specific screen when app is launched by tapping on deep link.
  void redirectFromDeepLink(Uri deepLink) {
    cprint("Found Url from share: ${deepLink.path}");
    var type = deepLink.path.split("/")[1];
    var id = deepLink.path.split("/")[2];
    if (type == "profilePage") {
      Navigator.push(context, ProfilePage.getRoute(profileId: id));
    } else if (type == "tweet") {
      var feedState = Provider.of<FeedState>(context, listen: false);
      feedState.getPostDetailFromDatabase(id);
      Navigator.push(context, FeedPostDetail.getRoute(id));
    }
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        child: _getPage(Provider.of<AppState>(context).pageIndex),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return FeedPage(
          scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );
      case 1:
        return NotificationPage(scaffoldKey: _scaffoldKey);
      case 2:
        return NotificationPage(scaffoldKey: _scaffoldKey);
      case 3:
        return FeedPage(scaffoldKey: _scaffoldKey);
      default:
        return FeedPage(scaffoldKey: _scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: const BottomMenubar(),
      drawer: const SidebarMenu(),
      body: _body(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(
    //     DiagnosticsProperty<StreamSubscription<PushNotificationModel>>(
    //         'pushNotificationSubscription', pushNotificationSubscription));
  }
}
