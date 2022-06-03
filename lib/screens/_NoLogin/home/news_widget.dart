import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListNewsCard extends StatelessWidget {
  const ListNewsCard({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.content,
    required this.press,
    required this.dateTimeEZ,
  }) : super(key: key);

  final String imageURL;
  final String title;
  final String content;
  final GestureTapCallback press;
  final dateTimeEZ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: GestureDetector(
        onTap: press,
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.only(bottom: 3.0),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color.fromARGB(179, 220, 220, 220), width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                //TODO : Image
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageURL),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(width: 8.0),

                //TODO : Title and Subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.length > 30
                            ? title.substring(0, 30) + '...'
                            : title,
                        style: Roboto16_B_green,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        content.length > 70
                            ? content.substring(0, 70) + '...'
                            : content,
                        style: Roboto14_gray,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10.0),
                      //TODO : Timestamp
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.clock,
                            color: Color(0xFFE0AB3A),
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            formattedDate(dateTimeEZ),
                            style: Roboto14_B_yellow,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  //===================================================================================================

  //TODO : Format Time 
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy').format(dateFromTimeStamp);
  }

}

