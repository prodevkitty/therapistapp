// import 'package:flutter/material.dart';
// import 'package:therapistapp/model/user.dart';
// import 'package:therapistapp/ui/page/profile/profilePage.dart';
// import 'package:therapistapp/ui/page/profile/widgets/circular_image.dart';
// import 'package:therapistapp/ui/page/settings/widgets/headerWidget.dart';
// import 'package:therapistapp/ui/page/settings/widgets/settingsRowWidget.dart';
// import 'package:therapistapp/state/chats/chatState.dart';
// import 'package:therapistapp/ui/theme/theme.dart';
// import 'package:therapistapp/widgets/customAppBar.dart';
// import 'package:therapistapp/widgets/customWidgets.dart';
// import 'package:therapistapp/widgets/url_text/customUrlText.dart';
// import 'package:therapistapp/widgets/newWidget/rippleButton.dart';
// import 'package:provider/provider.dart';

// class ConversationInformation extends StatelessWidget {
//   const ConversationInformation({Key? key}) : super(key: key);

//   Widget _header(BuildContext context, UserModel user) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 25),
//       child: Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.center,
//             child: SizedBox(
//                 height: 80,
//                 width: 80,
//                 child: RippleButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context, ProfilePage.getRoute(profileId: user.userId!));
//                   },
//                   borderRadius: BorderRadius.circular(40),
//                   child: CircularImage(path: user.profilePic, height: 80),
//                 )),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               UrlText(
//                 text: user.displayName!,
//                 style: TextStyles.onPrimaryTitleText.copyWith(
//                   color: Colors.black,
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(
//                 width: 3,
//               ),
//               user.isVerified!
//                   ? customIcon(
//                       context,
//                       icon: AppIcon.blueTick,
//                       isTwitterIcon: true,
//                       iconColor: AppColor.primary,
//                       size: 18,
//                       paddingIcon: 3,
//                     )
//                   : const SizedBox(width: 0),
//             ],
//           ),
//           customText(
//             user.userName,
//             style: TextStyles.onPrimarySubTitleText.copyWith(
//               color: Colors.black54,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: TwitterColor.white,
//       appBar: CustomAppBar(
//         isBackButton: true,
//         title: customTitleText(
//           'Conversation information',
//         ),
//       ),
//       body: ListView(
//         children: <Widget>[
//           _header(context, user),
//           const HeaderWidget('Notifications'),
//           const SettingRowWidget(
//             "Mute conversation",
//             visibleSwitch: true,
//           ),
//           Container(
//             height: 15,
//             color: TwitterColor.mystic,
//           ),
//           SettingRowWidget(
//             "Block ${user.userName}",
//             textColor: TwitterColor.dodgeBlue,
//             showDivider: false,
//           ),
//           SettingRowWidget("Report ${user.userName}",
//               textColor: TwitterColor.dodgeBlue, showDivider: false),
//           SettingRowWidget("Delete conversation",
//               textColor: TwitterColor.ceriseRed, showDivider: false),
//         ],
//       ),
//     );
//   }
// }
