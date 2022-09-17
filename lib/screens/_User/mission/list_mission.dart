import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class listTile_Mission extends StatefulWidget {
  const listTile_Mission({
    Key? key,
    required this.status,
    required this.title,
    required this.num_mission,
    required this.num_finish,
    required this.num_now,
    required this.reward_type,
    required this.reward_num,
  }) : super(key: key);
  final status;
  final title;
  final num_mission;
  final num_finish;
  final num_now;
  final reward_type;
  final reward_num;

  @override
  State<listTile_Mission> createState() => _listTile_MissionState();
}

class _listTile_MissionState extends State<listTile_Mission> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
                child: (widget.status == true)
                    ? Image.asset(
                        "assets/image/mission_com.png",
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
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
                        Text(widget.title, style: Roboto14_B_brown),
                        Text(widget.num_mission, style: Roboto14_B_brown),
                      ],
                    ),
                    const SizedBox(height: 5.0),

                    //TODO 3.2: Mission Bar
                    Stack(
                      children: [
                        build_missonBar(
                          color: const Color(0xFF522304),
                          width: 0.5,
                        ),
                        build_missonBar(
                          color: const Color(0xFFF0CB6A),
                          width:
                              ((widget.num_now / widget.num_finish) * 50) / 100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.num_now}/${widget.num_finish}',
                              style: Roboto14_B_white,
                            ),
                          ],
                        ),
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
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        color: (widget.status == true)
                            ? const Color(0xFF1CCC6A)
                            : const Color.fromARGB(155, 89, 85, 85),
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
                      type: widget.reward_type,
                      num_reward: widget.reward_num,
                      status: widget.status,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //==================================================================================================================
  //TODO : Mission Bar
  Widget build_missonBar({color, width}) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      height: 15,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
        ),
      ),
    );
  }

  //TODO : Reward in Button
  Widget build_reward({type, num_reward, status}) {
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
              (type == 'exp')
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
                (type == "exp") ? '$num_reward XP.' : '$num_reward RCT',
                style: (status == true) ? Roboto12_B_yellow : Roboto12_B_gray,
              ),
            ],
          ),
          //TODO : Text Button
          (status == true)
              ? Text(
                  'CLAIM',
                  style: Roboto14_B_white,
                )
              : Text(
                  'Reward',
                  style: Roboto14_B_black,
                )
        ],
      ),
    );
  }
}
