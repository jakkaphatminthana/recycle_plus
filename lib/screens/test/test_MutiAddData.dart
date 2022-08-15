import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Test_MutiData extends StatefulWidget {
  const Test_MutiData({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/TestMutidata";

  @override
  State<Test_MutiData> createState() => _Test_MutiDataState();
}

class _Test_MutiDataState extends State<Test_MutiData> {
  //TODO : Add Single Collection
  Future addCollection() async {
    CollectionReference data = FirebaseFirestore.instance.collection('test');
    var uid = Uuid();
    final uuid = uid.v1();

    //แบบมั่ว ID
    // await data.add({
    //   'id': data.id,
    //   'name': "Test555",
    // }).then((value) => print("Created"));

    //แบบ uid
    await data.doc(uuid).set({
      "id": uuid,
      "name": "fixID",
    }).then((value) => print("Created"));

    //TODO : HighLight <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    await addMutiCollections(idEZ: uuid);
  }

  //TODO : Add Muti Collections
  Future addMutiCollections({String? idEZ}) async {
    CollectionReference data2 = FirebaseFirestore.instance.collection('test');

    await data2.doc(idEZ).collection('sub_collection').add({
      "id": data2.id,
      "name": "2st data",
    }).then((value) => print("Success"));
  }

  //TODO : Add Muti Collections
  Future addMutiCollectionsWithUsers({String? idEZ}) async {
    CollectionReference data2 = FirebaseFirestore.instance.collection('test');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    //==============================================================================================
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            //TODO 1: Button Add Muti Data
            ElevatedButton(
              child: const Text("Add MutiData"),
              onPressed: () {
                addCollection();
              },
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
