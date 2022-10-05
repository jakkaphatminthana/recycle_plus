import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/list_missionExam.dart';

class AddMission3 extends StatefulWidget {
  AddMission3({
    Key? key,
    required this.typeMission,
    required this.category,
    required this.title,
    required this.num_finish,
    required this.reward,
    required this.num_reward,
    required this.trash,
  }) : super(key: key);

  TextEditingController typeMission = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController num_finish = TextEditingController();
  TextEditingController reward = TextEditingController();
  TextEditingController num_reward = TextEditingController();
  TextEditingController trash = TextEditingController(); //กรณีที่ภารกิจ trash

  @override
  State<AddMission3> createState() => _AddMission3State();
}

class _AddMission3State extends State<AddMission3> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  final formKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TODO 1: Header
        Row(
          children: [
            Text("ข้อมูลภารกิจ", style: Roboto18_B_black),
            const Icon(
              Icons.sports_soccer_rounded,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 15.0),

        //TODO 2: TextContent
        TextRow('ภารกิจแบบ:', widget.typeMission.text),
        TextRow('หมวดหมู่:', widget.category.text),
        (widget.trash.text != '')
            ? TextRow('ขยะประเภท:', widget.trash.text)
            : Container(),
        TextRow('หัวข้องาน:', widget.title.text),
        TextRow('ของรางวัล:', widget.reward.text),
        const SizedBox(height: 15.0),

        //TODO 3: Example Result
        Text('ตัวอย่างผลลัพธ์:', style: Roboto16_B_black),
        const SizedBox(height: 15.0),

        list_MissionExample(
          mission_type: widget.category.text,
          title: widget.title.text,
          num_finish: widget.num_finish.text,
          reward_type: widget.reward.text,
          reward_num: widget.num_reward.text,
          trash: widget.trash.text,
        ),
      ],
    );
  }

  //=============================================================================================================
  //TODO 1: TextRow
  Widget TextRow(String? title, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Text(title!, style: Roboto14_B_black),
          const SizedBox(width: 5.0),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(subtitle!, style: Roboto14_B_greenB),
          ),
        ],
      ),
    );
  }
}
