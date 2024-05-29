// import 'package:flutter/material.dart';

// class ChatBottomBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 65,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.all(5),
//               padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.emoji_emotions_outlined,
//                     color: Colors.black38,
//                     size: 30,
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: TextFormField(
//                       style: TextStyle(
//                         fontSize: 19,
//                       ),
//                       decoration: InputDecoration(
//                         hintText: "Message",
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   Transform.rotate(
//                     angle: 230 * 3.141592653589793 / 180,
//                     child: Icon(
//                       Icons.attachment_rounded,
//                       color: Colors.black38,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Icon(Icons.camera_alt, color: Colors.black38, size: 30),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5),
//             child: Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 37, 128, 100),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Icon(
//                 Icons.mic,
//                 size: 30,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
