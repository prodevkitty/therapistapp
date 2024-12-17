import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapistapp/helper/enum.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/state/authState.dart';
import 'package:therapistapp/ui/page/Auth/selectAuthMethod.dart';
import 'package:therapistapp/ui/page/Auth/signin.dart';
import 'package:therapistapp/ui/page/common/updateApp.dart';
import 'package:therapistapp/ui/page/homePage.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  /// Check if current app is updated app or not
  /// If app is not updated then redirect user to update app screen
  void timer() async {
    cprint("App is updated");
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      // var state = Provider.of<AuthState>(context, listen: false);
      // state.getCurrentUser(context: context);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = (sharedPreferences.get('token') ?? '') as String;
      // API call
      if (token.isNotEmpty) {
        var state = Provider.of<AuthState>(context, listen: false);
        if (state.isbusy) {
          return;
        }
        String? res = await state.loginJwt(token, context: context);

        if (res != null) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('token', res);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignIn(),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignIn(),
          ),
        );
      }
    });
  }

  /// Return installed app version
  /// For testing purpose in debug mode update screen will not be open up
  /// If an old version of app is installed on user's device then
  /// User will not be able to see home screen
  /// User will redirected to update app screen.
  /// Once user update app with latest version and back to app then user automatically redirected to welcome / Home page

  Widget _body() {
    var height = 150.0;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(50),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Platform.isIOS
                  ? const CupertinoActivityIndicator(
                      radius: 35,
                    )
                  : const CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
              Image.asset(
                'assets/images/icon-480.png',
                height: 30,
                width: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return Scaffold(
      backgroundColor: TwitterColor.white,
      body: state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : state.authStatus == AuthStatus.NOT_LOGGED_IN
              ? const SignIn()
              : const HomePage(),
    );
  }
}
