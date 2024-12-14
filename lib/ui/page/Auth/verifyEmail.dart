import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/state/authState.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _body(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    bool emailVerified = state.userModel?.isEmailVerified ?? false;

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: emailVerified
            ? <Widget>[
                NotifyText(
                  title: 'Your email address is verified',
                  subTitle:
                      'You have got your blue tick on your name. Cheers !!',
                ),
              ]
            : <Widget>[
                NotifyText(
                  title: 'Verify your email address',
                  subTitle:
                      'Send email verification email link to ${state.userModel?.email} to verify address',
                ),
                const SizedBox(
                  height: 30,
                ),
                _submitButton(context),
              ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var state = Provider.of<AuthState>(context, listen: false);
        await state.sendEmailVerification();
        Utility.customSnackBar(context, 'Verification email sent');
      },
      child: Text('Send Verification Email'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: _body(context),
    );
  }
}

class NotifyText extends StatelessWidget {
  final String title;
  final String subTitle;

  const NotifyText({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          subTitle,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}