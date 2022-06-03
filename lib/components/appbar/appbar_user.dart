import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_NoLogin/tabbar_control.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../screens/_Admin/tabbar_control.dart';

class Appbar_member extends AppBar {
  final GestureTapCallback press;

  Appbar_member({required this.press})
      : super(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: GestureDetector(
              onTap: press,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/image/logo.png",
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("RECYCLE+", style: Roboto18_B_white),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.qr_code,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.solidUserCircle,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {},
            ),
          ],
          elevation: 2.0,
        );
}
  

// return AppBar(
//       backgroundColor: const Color(0xFF00883C),
//       automaticallyImplyLeading: false,
//       title: Padding(
//         padding: const EdgeInsets.only(left: 10.0),
//         child: GestureDetector(
//           onTap: () =>
//               Navigator.popAndPushNamed(context, Member_TabbarHome.routeName),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(
//                 "assets/image/logo.png",
//                 width: 30,
//                 height: 30,
//                 fit: BoxFit.cover,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0),
//                 child: Text("RECYCLE+", style: Roboto18_B_white),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(
//             Icons.qr_code,
//             color: Colors.white,
//             size: 35,
//           ),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: const FaIcon(
//             FontAwesomeIcons.solidUserCircle,
//             color: Colors.white,
//             size: 30,
//           ),
//           onPressed: () {},
//         ),
//       ],
//       elevation: 2.0,
//     );