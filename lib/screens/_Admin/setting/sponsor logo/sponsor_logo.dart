import 'package:flutter/material.dart';

import '../../../../components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Admin_LogoSponsor extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_LogoSponsor";

  @override
  State<Admin_LogoSponsor> createState() => _Admin_LogoSponsorState();
}

class _Admin_LogoSponsorState extends State<Admin_LogoSponsor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        centerTitle: true,
        title: Text("Sponosor Logo", style: Roboto18_B_white),
        //Icon Menu bar
        actions: [
          IconButton(
            icon: const FaIcon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
        elevation: 2.0,
      ),
      //----------------------------------------------------------------------------------
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 10.0),

                    //TODO : GridView Setting
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: GridView(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.85,
                          ),
                          scrollDirection: Axis.vertical,
                          children: [
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
