import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/mission/edit/mission_edit.dart';

class ListTile_MissionAdmin extends StatelessWidget {
  const ListTile_MissionAdmin({
    Key? key,
    required this.data,
    required this.category,
    required this.title,
    required this.num_finish,
    required this.reward_type,
    required this.reward_num,
    required this.trash,
  }) : super(key: key);

  final data;
  final String category;
  final String title;
  final int num_finish;
  final String reward_type;
  final double reward_num;
  final String trash;

  @override
  Widget build(BuildContext context) {
    String unit =
        (category == 'Recycle' || category == "Login") ? 'ครั้ง' : 'ชิ้น';
    Color tagColor = (category == 'Recycle')
        ? const Color(0xFF3AD4C2)
        : (category == "Login")
            ? const Color(0xFFEF8C61)
            : (category == "Trash")
                ? const Color(0xFFDE5CB1)
                : const Color(0xFFDE5CB1);
    //==============================================================================================================
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Admin_MissionEdit(data: data)),
          );
        },
        //TODO 1: Contaner
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                //TODO 2: Icon Image
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Image.asset(
                    "assets/image/mission.png",
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 5.0),

                //TODO 3: Detail Mission
                Container(
                  width: MediaQuery.of(context).size.width * 0.46,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO 3.1: Text title
                      Row(
                        children: [
                          Text(title, style: Roboto14_B_brown),
                          TextPending(
                            Text(" $trash", style: Roboto14_B_brown),
                          ),
                          TextPending(
                            Text(" $num_finish", style: Roboto14_B_brown),
                          ),
                          Text(" $unit", style: Roboto14_B_brown),
                        ],
                      ),
                      const SizedBox(height: 5.0),

                      //TODO 3.2: Badge Tag
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BadgeTag(tagColor, category),
                          const SizedBox(width: 5.0),
                          (trash == '')
                              ? Container()
                              : BadgeTag(const Color(0xFF8074F0), trash),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5.0),

                //TODO 4: Button Reward
                GestureDetector(
                  onTap: () {},
                  child: Material(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                          color: const Color(0xFF15984F),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0x32000000),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 1,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ]),
                      child: build_reward(
                        type: reward_type,
                        num_reward: reward_num,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //==================================================================================================================
  //TODO : Reward in Button
  Widget build_reward({type, num_reward}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO : Reward num
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (type == 'Exp')
                  ? Image.asset(
                      'assets/image/exp2.png',
                      width: 12,
                      height: 12,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/image/token.png',
                      width: 15,
                      height: 15,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(width: 5.0),
              Text(
                (type == "Exp") ? '$num_reward XP.' : '$num_reward RCT',
                style: Roboto12_B_yellow,
              ),
            ],
          ),
          //TODO : Text Button
          Text('Reward', style: Roboto14_B_white)
        ],
      ),
    );
  }

  //TODO : Save Pending text
  Widget TextPending(textEZ) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: textEZ,
    );
  }

  //TODO : Badge Tag
  Widget BadgeTag(colorEZ, title) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: colorEZ,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(title, style: Roboto14_B_black),
      ),
    );
  }
}
