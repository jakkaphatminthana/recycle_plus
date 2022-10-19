import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../service/auth.dart';
import '../../login/body_login.dart';
import '../Form/Moresupportform.dart';
import '../Status/Supportstatus.dart';

class Sponsor_HomeScreen extends StatefulWidget {
  const Sponsor_HomeScreen({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/home_sponsor";

  @override
  State<Sponsor_HomeScreen> createState() => _Sponsor_HomeScreenState();
}

class _Sponsor_HomeScreenState extends State<Sponsor_HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService auth = AuthService();
  User? user = FirebaseAuth.instance.currentUser;
  late String company = '';
  late String imageSponsor = '';
  late String otp = '';

  Future importSpondataU() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        otp = value.data()!["otp"];
        print("otppppppppppppppppppppppppppppppppp $otp");
      });
      importSpondata();
    });
  }

  Future importSpondata() async {
    FirebaseFirestore.instance
        .collection('sponsor')
        .doc(otp)
        .snapshots()
        .listen((value) {
      setState(() {
        company = value.get("company");
        imageSponsor = value.get("image");
        print(company);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    importSpondataU();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Home',
          ),
          backgroundColor: const Color(0xFF00883C),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut().then(
                      (value) => Navigator.popAndPushNamed(
                        context,
                        LoginScreen.routeName,
                      ),
                    );
              },
            )
          ],
          centerTitle: true,
          elevation: 2,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('sponsor')
              .where('user_ID', isEqualTo: user!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/image/bg-green1.jpg'),
                      fit: BoxFit.cover)),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: const BoxDecoration(
                          color: Color(0xFF107027),
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 10)
                          ]),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 0, 0, 0),
                            child: Image.network(
                              '${imageSponsor}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                25, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$company',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 25, 0, 0),
                                  child: Text(
                                    '${user!.email}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                      child: SizedBox(
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 100,
                            decoration: BoxDecoration(
                                color: const Color(0xFF69AFEB),
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'ดูความเคลื่อนใหวการสนับสนุน',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Supportstatus()),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: SizedBox(
                          child: InkWell(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 250, 149, 25),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'สนับสนุนเพิ่มเติม',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MoreSupportform()));
                            },
                          ),
                        )),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
