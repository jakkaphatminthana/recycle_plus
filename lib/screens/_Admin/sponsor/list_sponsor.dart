import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';


import 'edit_sponsor/admin_sponsorEdit.dart';

class ListTile_Admin_Sponsor extends StatelessWidget {
  const ListTile_Admin_Sponsor({
    Key? key,
    required this.data,
    required this.company,
    required this.image,
    required this.email,
    required this.money,
    required this.status,
  }) : super(key: key);

  final data;
  final company;
  final image;
  final email;
  final money;
  final status;

  @override
  Widget build(BuildContext context) {
    String imageCon = (image == '')
        ? 'https://firebasestorage.googleapis.com/v0/b/recycleplus-feecd.appspot.com/o/images%2Fspon_default.png?alt=media&token=b01c9ae2-1780-4e56-bac0-9829e683663f'
        : image;
    String emailCon = (email == '') ? 'รอการลงทะเบียน' : email;
    //===========================================================================================================
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Admin_SponsorEdit(data: data)),
        );
      },
      child: Material(
        color: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        //TODO 1: Container Main
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            boxShadow: const [
              BoxShadow(
                color: Color(0x7F000000),
                offset: Offset(1, 1.5),
              )
            ],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xB29F9F9F),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                //TODO 2: Container 70%
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 1,
                  child: Row(
                    children: [
                      //TODO 3: Image Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              imageCon,
                              width: 70,
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),

                      //TODO 4: name company
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //TEXT Company name
                            Text(
                              (company.length > 22)
                                  ? company.substring(0, 22) + "..."
                                  : company,
                              style: Roboto14_B_greenB,
                            ),
                            //TEXT User email
                            Row(
                              children: [
                                Text('email: ', style: Roboto14_B_black),
                                Text(
                                  (emailCon.length > 25)
                                      ? emailCon.substring(0, 25) + "..."
                                      : emailCon,
                                  style: Roboto12_black,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),

                            //TODO 5: Donet Amount
                            Row(
                              children: [
                                const FaIcon(
                                  Icons.monetization_on_outlined,
                                  color: Color(0xFF2975C0),
                                  size: 25,
                                ),
                                const SizedBox(width: 5.0),
                                Text('$money', style: Roboto16_B_black),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //TODO 3. Container 10%
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (status == true)
                          ? Column(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                Text(
                                  "Passed",
                                  style: Roboto14_B_greenB,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.orangeAccent,
                                  size: 30,
                                ),
                                Text(
                                  "Waiting",
                                  style: Roboto14_B_orange,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
