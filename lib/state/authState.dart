import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:therapistapp/helper/enum.dart';
import 'package:therapistapp/helper/shared_prefrence_helper.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/model/user.dart';
import 'package:therapistapp/ui/page/common/locator.dart';
import 'appState.dart';

class AuthState extends AppState {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  late String userId;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  UserModel? get profileUserModel => _userModel;

  /// Logout from device
  void logoutCallback() async {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    _userModel = null;
    notifyListeners();
    await getIt<SharedPreferenceHelper>().clearPreferenceValues();
  }

  /// Alter select auth method, login and sign up page
  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    notifyListeners();
  }

  /// Verify user's credentials for login
  Future<String?> signIn(String email, String password,
      {required BuildContext context}) async {
    try {
      isBusy = true;
      final response = await http.post(
        Uri.parse('http://localhost:8001/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userId = data['user_id'];
        _userModel = UserModel.fromJson(data['user']);
        authStatus = AuthStatus.LOGGED_IN;
        notifyListeners();
        return userId;
      } else {
        Utility.customSnackBar(context, 'Invalid credentials');
        return null;
      }
    } catch (error) {
      Utility.customSnackBar(context, error.toString());
      return null;
    } finally {
      isBusy = false;
    }
  }

  /// Create new user's profile in db
  Future<String?> signUp(UserModel userModel,
      {required BuildContext context, required String password}) async {
    try {
      isBusy = true;
      final response = await http.post(
        Uri.parse('http://localhost:8001/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': userModel.email!,
          'password': password,
          'displayName': userModel.displayName!,
          'profilePic': userModel.profilePic!,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userId = data['user_id'];
        _userModel = UserModel.fromJson(data['user']);
        authStatus = AuthStatus.LOGGED_IN;
        notifyListeners();
        return userId;
      } else {
        Utility.customSnackBar(context, 'Registration failed');
        return null;
      }
    } catch (error) {
      Utility.customSnackBar(context, error.toString());
      return null;
    } finally {
      isBusy = false;
    }
  }

  /// Fetch current user profile
  Future<UserModel?> getCurrentUser({required BuildContext context}) async {
    try {
      isBusy = true;
      final response = await http.get(
        Uri.parse('http://localhost:8001/current_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userId = data['user_id'];
        _userModel = UserModel.fromJson(data['user']);
        authStatus = AuthStatus.LOGGED_IN;
        notifyListeners();
        return null;
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
        return null;
      }
    } catch (error) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      Utility.customSnackBar(context, error.toString());
      return null;
    } finally {
      isBusy = false;
    }
  }

  /// Send password reset link to email
  Future<void> forgetPassword(String email,
      {required BuildContext context}) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8001/forgot_password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        Utility.customSnackBar(context,
            'A reset password link is sent to your email. You can reset your password from there.');
      } else {
        Utility.customSnackBar(context, 'Failed to send reset password link');
      }
    } catch (error) {
      Utility.customSnackBar(context, error.toString());
    }
  }

  /// `Update user` profile
  Future<void> updateUserProfile(UserModel? userModel,
      {File? image, File? bannerImage, required BuildContext context}) async {
    try {
      if (image == null && bannerImage == null) {
        final response = await http.put(
          Uri.parse('http://localhost:8001/update_profile'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(userModel!.toJson()),
        );

        if (response.statusCode == 200) {
          _userModel = userModel;
          notifyListeners();
        } else {
          Utility.customSnackBar(context, 'Failed to update profile');
        }
      } else {
        // Handle image upload separately if needed
      }
    } catch (error) {
      Utility.customSnackBar(context, error.toString());
    }
  }

  /// `Fetch` user `detail` whose userId is passed
  Future<UserModel?> getUserDetail(String userId, {required BuildContext context}) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8001/user/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        return null;
      }
    } catch (error) {
      Utility.customSnackBar(context, error.toString());
      return null;
    }
  }

  /// Fetch user profile
  /// If `userProfileId` is null then logged in user's profile will fetched
  FutureOr<void> getProfileUser({String? userProfileId, required BuildContext context}) async {
    try {
      userProfileId = userProfileId ?? userId;
      final response = await http.get(
        Uri.parse('http://localhost:8001/profile/$userProfileId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userModel = UserModel.fromJson(data);
        notifyListeners();
      }
    } catch (error) {
      Utility.customSnackBar(context, error.toString());
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    // Simulate sending email verification
    await Future.delayed(Duration(seconds: 2));
    cprint('Verification email sent');
  }
}