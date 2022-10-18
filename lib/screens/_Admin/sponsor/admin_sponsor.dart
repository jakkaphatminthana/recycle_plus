import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/list_sponsor.dart';
import 'add/dialog_add.dart';

class Admin_SponsorManager extends StatefulWidget {
  const Admin_SponsorManager({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_Sponsor";

  @override
  State<Admin_SponsorManager> createState() => _Admin_SponsorManagerState();
}

class _Admin_SponsorManagerState extends State<Admin_SponsorManager> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream_sponsor =
        FirebaseFirestore.instance.collection('sponsor').snapshots();
    //================================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("Sponsor Management", style: Roboto16_B_white),
          actions: [
            IconButton(
              icon: const FaIcon(
                Icons.addchart_sharp,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _stream_sponsor,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const SpinKitCircle(
                        color: Colors.green,
                        size: 40,
                      );
                    } else {
                      return ListView(
                        children: [
                          //TODO : Fetch data here
                          ...snapshot.data!.docs
                              .map((QueryDocumentSnapshot<Object?> data) {
                            //ได้ตัว Data มาละ ----------<<<
                            final company = data.get("company");
                            final image = data.get("image");
                            final email = data.get("email");
                            final money = data.get("money");
                            final status = data.get("status");

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: ListTile_Admin_Sponsor(
                                data: data,
                                company: company,
                                image: image,
                                email: email,
                                money: money,
                                status: status,
                              ),
                            );
                          }),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        //TODO : ปุ่มกดมุมขวาล่าง
        floatingActionButton: buildFloatingButton(),
      ),
    );
  }

  //===============================================================================================================
  //TODO : Action Add Sponsor
  Widget buildFloatingButton() => FloatingActionButton(
        child: const Icon(Icons.add_business, size: 35),
        backgroundColor: const Color(0xFF00883C),
        onPressed: () {
          // Navigator.pushNamed(context, Admin_AddMission.routeName);
          showDialogAddSponsor(context: context);
        },
      );
}
