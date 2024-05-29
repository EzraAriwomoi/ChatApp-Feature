// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ult_whatsapp/common/models/user_model.dart';
// import 'package:ult_whatsapp/pages/chatbottombar.dart';
// import 'package:ult_whatsapp/pages/chatsample.dart';

// class ChatPage extends StatelessWidget {
//   const ChatPage({super.key, required this.user});

//   final UserModel user;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(65),
//         child: AppBar(
//           backgroundColor: const Color.fromARGB(255, 37, 128, 100),
//           elevation: 0,
//           leading: Padding(
//             padding: EdgeInsets.only(top: 10, left: 5),
//             child: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 size: 25,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           leadingWidth: 20,
//           title: Padding(
//             padding: EdgeInsets.only(top: 6),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(30),
//                   child: Image.asset(
//                     "assets/user.jpg",
//                     height: 45,
//                     width: 45,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "User",
//                         style: TextStyle(
//                           fontSize: 19,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         "online",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.white.withOpacity(.8),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: EdgeInsets.only(top: 10, right: 25),
//               child: Icon(
//                 CupertinoIcons.video_camera_solid,
//                 size: 35,
//                 color: Colors.white,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 10, right: 25),
//               child: Icon(
//                 Icons.call,
//                 size: 25,
//                 color: Colors.white,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 10, right: 25),
//               child: Icon(
//                 Icons.more_vert,
//                 size: 28,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//               "assets/light.png",
//             ),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 80),
//             child: Column(
//               children: [
//                 Container(
//                   width: 370,
//                   margin: EdgeInsets.only(bottom: 20),
//                   padding: EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFFFF3C2),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         blurRadius: 8,
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Transform.translate(
//                         offset: Offset(11, -8), // Adjust the value as needed
//                         child: Icon(
//                           Icons.lock,
//                           size: 12,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(
//                           width:
//                               5), // Adjust the spacing between the icon and text as needed
//                       Expanded(
//                         child: Text(
//                           "Messages and calls are end-to-end encrypted. No one outside of this chat, not even WhatsApp, can read or listen to them. Tap to learn more.",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ChatSample(),
//                 ChatSample(),
//                 ChatSample(),
//                 ChatSample(),
//                 ChatSample(),
//                 ChatSample(),
//                 ChatSample(),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomSheet: ChatBottomBar(),
//     );
//   }
// }
