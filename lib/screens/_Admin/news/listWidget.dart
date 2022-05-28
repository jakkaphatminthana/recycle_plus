import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.subtitle,
    required this.press,
  }) : super(key: key);

  final String imageURL;
  final String title;
  final String subtitle;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 3.0),
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
                    title.length > 30 ? title.substring(0, 30) + '...' : title,
                    style: Roboto16_B_green,
                  ),
                  Text(
                    subtitle.length > 60
                        ? subtitle.substring(0, 60) + '...'
                        : subtitle,
                    style: Roboto14_gray,
                  ),
                  const SizedBox(height: 5.0),
                  //TODO : Timestamp
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20,),
                      const SizedBox(width: 5.0,),
                      Text("20/05/2565", style: Roboto12_black),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
