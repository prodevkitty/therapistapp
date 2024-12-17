// import 'package:flutter/material.dart';
// import 'package:therapistapp/helper/enum.dart';
// import 'package:therapistapp/ui/page/Auth/signup.dart';
// import 'package:therapistapp/state/authState.dart';
// import 'package:therapistapp/ui/theme/theme.dart';
// import 'package:therapistapp/widgets/customFlatButton.dart';
// import 'package:therapistapp/widgets/newWidget/title_text.dart';
// import 'package:provider/provider.dart';
// import '../homePage.dart';
// import 'signin.dart';

// class WelcomePage extends StatefulWidget {
//   const WelcomePage({Key? key}) : super(key: key);

//   @override
//   _WelcomePageState createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   Widget _submitButton() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 15),
//       width: MediaQuery.of(context).size.width,
//       child: CustomFlatButton(
//         label: "Create Account",
//         onPressed: () {
//           var state = Provider.of<AuthState>(context, listen: false);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Signup(loginCallback: () => state.getCurrentUser(context: context)),
//             ),
//           );
//         },
//         borderRadius: 30,
//       ),
//     );
//   }

//   Widget _body() {
//     return SafeArea(
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 40,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const SizedBox(
//               height: 200,
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width - 80,
//               height: 100,
//               child: Image.asset('assets/images/logo_therabot_with_name.png'),
//             ),
//             const Spacer(),
//             const Center(
//               child: TitleText(
//                 'Welcome to TheraBot!',
//                 fontSize: 25,
//                 color: Color(0xFF1DA1F2),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             _submitButton(),
//             const Spacer(),
//             Wrap(
//               alignment: WrapAlignment.center,
//               crossAxisAlignment: WrapCrossAlignment.center,
//               children: <Widget>[
//                 const TitleText(
//                   'Have an account already?',
//                   fontSize: 14,
//                   fontWeight: FontWeight.w300,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     var state = Provider.of<AuthState>(context, listen: false);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             SignIn(loginCallback: () => state.getCurrentUser(context: context)),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
//                     child: TitleText(
//                       ' Log in',
//                       fontSize: 14,
//                       color: TwitterColor.dodgeBlue,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 20)
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var state = Provider.of<AuthState>(context, listen: false);
//     return Scaffold(
//       body: state.authStatus == AuthStatus.NOT_LOGGED_IN ||
//               state.authStatus == AuthStatus.NOT_DETERMINED
//           ? _body()
//           : const HomePage(),
//     );
//   }
// }
