import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Form/Supportform.dart';

class SponsorMember extends StatefulWidget {
  const SponsorMember({Key? key}) : super(key: key);

  @override
  State<SponsorMember> createState() => _SponsorMemberState();
}

class _SponsorMemberState extends State<SponsorMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF00883C),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Supportform()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          'สปอนเซอร์ที่สนับสนุน',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF00883C),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sponsor')
            .where('status', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              final pullimage = document['image'];
              if (pullimage == '') {
                return Container();
              } else {
                return Padding(
                  padding: EdgeInsets.all(15),
                  child: SizedBox(
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: FittedBox(
                            child: Image.network(
                              document['image'],
                            ),
                          ),
                        ),
                        title: Text(
                          document['company'],
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Row(
                          children: [
                            Text('จำนวนเงินที่บริจาค'),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(document['money'].toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
