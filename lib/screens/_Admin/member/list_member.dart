import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/member/member_edit/member_edit.dart';

import 'member_detail/member_detail.dart';

class ListTile_Member extends StatelessWidget {
  const ListTile_Member({
    Key? key,
    required this.data,
    required this.image,
    required this.email,
    required this.role,
    this.level,
    this.otp,
  }) : super(key: key);

  final data;
  final image;
  final email;
  final role;

  final level;
  final otp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Admin_MemberDetail(data: data)),
        ),
        child: Material(
          elevation: 3,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    height: MediaQuery.of(context).size.height,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //TODO 1: Image
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                            ),
                          ),
                          child: Container(
                            width: 45,
                            height: 45,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(image),
                          ),
                        ),
                        const SizedBox(width: 10.0),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //TODO 2: Email
                            Text(email, style: Roboto14_B_black),
                            const SizedBox(height: 5.0),

                            Row(
                              children: [
                                //TODO 3: Icon Role
                                (role == "Member")
                                    ? TextRowIcon(
                                        iconEZ: Icons.person,
                                        colorEZ: const Color(0xFF15984F),
                                        text: role,
                                      )
                                    : TextRowIcon(
                                        iconEZ: Icons.person,
                                        colorEZ: const Color(0xFFF6A94C),
                                        text: role,
                                      ),
                                const SizedBox(width: 8.0),

                                //TODO 4: Icon seconut
                                (role == "Member")
                                    ? TextRowIcon(
                                        iconEZ: Icons.star_purple500_outlined,
                                        colorEZ: const Color(0xFFF6A94C),
                                        text: "Lv. $level",
                                      )
                                    : TextRowIcon(
                                        iconEZ: Icons.insert_link,
                                        colorEZ: Colors.black,
                                        text: " $otp",
                                      )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  //TODO : Container Arrow
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    decoration: const BoxDecoration(),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //================================================================================================================
  Widget TextRowIcon(
      {required IconData iconEZ, required Color colorEZ, required text}) {
    return Row(
      children: [
        FaIcon(iconEZ, color: colorEZ, size: 18),
        Text(
          text,
          style: GoogleFonts.getFont(
            'Roboto',
            fontSize: 14,
            color: colorEZ,
          ),
        ),
      ],
    );
  }
}
