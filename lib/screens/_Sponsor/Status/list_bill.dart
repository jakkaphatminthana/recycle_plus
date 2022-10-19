import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/bill/edit_bill/edit_bill.dart';

class ListTile_Bill extends StatelessWidget {
  const ListTile_Bill({
    Key? key,
    required this.file,
    required this.time,
    required this.title,
    required this.money,
  }) : super(key: key);
  final file;
  final time;
  final title;
  final money;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO 1: TimeDate
          Text(formattedDate(time), style: Roboto14_B_black),
          const SizedBox(height: 5.0),

          //TODO 2: Container
          Material(
            color: Colors.transparent,
            elevation: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2F6),
                border: Border.all(
                  color: const Color(0xB4000000),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                child: Row(
                  children: [
                    //TODO 3: Icon Image
                    const FaIcon(
                      FontAwesomeIcons.fileDownload,
                      color: Color(0xFFFC5963),
                      size: 30,
                    ),

                    const SizedBox(width: 15.0),

                    //TODO 4: Container 60%
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.56,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //TODO 4.1: Text Title
                            Text(
                              title.length > 25
                                  ? title.substring(0, 25) + '...'
                                  : title,
                              style: Roboto16_B_red,
                            ),
                            const SizedBox(height: 5.0),

                            //TODO 4.2: Money
                            Row(
                              children: [
                                const Icon(
                                  Icons.monetization_on_outlined,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                const SizedBox(width: 5.0),
                                Text('$money บาท', style: Roboto14_B_black),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    //TODO 5: Click to download
                    GestureDetector(
                      onTap: () => downloadFile(ref: file, context: context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.download_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text('Download', style: Roboto12_B_black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //================================================================================================================
  //TODO : Format time
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy (HH:mm)').format(dateFromTimeStamp);
  }

  //TODO : Download File
  Future downloadFile({required ref, required BuildContext context}) async {
    Reference fileRef = await FirebaseStorage.instance.refFromURL(ref);
    final url = await fileRef.getDownloadURL();

    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${fileRef.name}';
    await Dio().download(url, path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download: ${fileRef.name}')),
    );
  }
}
