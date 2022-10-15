import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

import 'edit/achievement_edit.dart';

class CardHonor_Admin extends StatefulWidget {
  const CardHonor_Admin({
    Key? key,
    required this.data,
    required this.title,
    required this.image,
    required this.num_finish,
    required this.achi_category,
    required this.trash,
  }) : super(key: key);
  final data;
  final title;
  final image;
  final num_finish;
  final achi_category;
  final trash;

  @override
  State<CardHonor_Admin> createState() => _CardHonor_AdminState();
}

class _CardHonor_AdminState extends State<CardHonor_Admin> {
  String? category_quest;
  String? unit;

  //TODO : First call whenever run
  @override
  void initState() {
    super.initState();
    //Set value คำอธิบายคร่าวๆ
    if (widget.achi_category == "Login") {
      category_quest = "เช็คอินสะสม";
      unit = ' วัน';
    } else if (widget.achi_category == "Recycle") {
      category_quest = "รีไซเคิลขยะ";
      unit = ' ครั้ง';
    } else if (widget.achi_category == "Trash") {
      category_quest = "รีไซเคิล ${widget.trash}";
      unit = " ชิ้น";
    } else if (widget.achi_category == "Level") {
      category_quest = "ระดับเลเวลถึง Lv.";
      unit = "";
    } else {
      category_quest = "ผิดพลาด";
      unit = "";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //=============================================================================================================
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Admin_AchievementEdit(
              data: widget.data,
            ),
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 100,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF357450),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                //TODO 1: Title Name
                Text(widget.title, style: Roboto16_B_white),
                const SizedBox(height: 8.0),

                //TODO 2: Image Honor
                Image.network(
                  widget.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5.0),

                //TODO 3: quest Text
                Text(
                  '$category_quest ${widget.num_finish}${unit}',
                  style: Roboto14_B_white,
                ),
                const SizedBox(height: 5.0),

                Text('(0/${widget.num_finish})', style: Roboto14_white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
