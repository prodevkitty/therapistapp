import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:therapistapp/helper/enum.dart';
import 'package:therapistapp/helper/shared_prefrence_helper.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/model/user.dart';
import 'package:therapistapp/state/appState.dart';
import 'package:therapistapp/ui/page/common/locator.dart';

enum StateType { following, follower }

class FollowListState extends AppState {
  FollowListState(StateType type) {
    isBusy = true;
    getIt<SharedPreferenceHelper>().getUserProfile().then((user) {
      if (user != null) {
        _currentUser = user;
        isBusy = false;
      }
    });
    stateType = type;
  }

  UserModel? _currentUser;
  late StateType stateType;

  /// Follow / Unfollow user
  Future<void> followUser(UserModel secondUser) async {
    bool isFollowing = isFollowingUser(secondUser);

    try {
      if (isFollowing) {
        secondUser.followersList!.remove(_currentUser!.userId);
        _currentUser!.followingList!.remove(secondUser.userId);
        cprint('user removed from following list');
      } else {
        secondUser.followersList ??= [];
        secondUser.followersList!.add(_currentUser!.userId!);
        _currentUser!.followingList ??= [];
        addFollowNotification(secondUser.userId!);
        _currentUser!.followingList!.add(secondUser.userId!);
        cprint('user added from following list');
      }

      secondUser.followers = secondUser.followersList!.length;
      _currentUser!.following = _currentUser!.followingList!.length;

      final response1 = await http.put(
        Uri.parse('http://localhost:8001/profile/${secondUser.userId}/followers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(secondUser.followersList),
      );

      if (response1.statusCode != 200) {
        throw Exception('Failed to update second user profile');
      }

      final response2 = await http.put(
        Uri.parse('http://localhost:8001/profile/${_currentUser!.userId}/following'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(_currentUser!.followingList),
      );

      if (response2.statusCode != 200) {
        throw Exception('Failed to update current user profile');
      }

      cprint('Operation Success');
      await getIt<SharedPreferenceHelper>().saveUserProfile(_currentUser!);

      notifyListeners();
    } catch (error) {
      cprint(error, errorIn: 'followUser');
    }
  }

  bool isFollowingUser(UserModel user) {
    return user.followersList?.contains(_currentUser!.userId) ?? false;
  }

  void addFollowNotification(String profileId) {
    // Implement your custom notification logic here
  }
}