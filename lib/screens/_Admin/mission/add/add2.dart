import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/textfield_mission.dart';

class AddMission2 extends StatefulWidget {
  AddMission2({
    Key? key,
    required this.reward,
    required this.num_reward,
  }) : super(key: key);

  TextEditingController reward = TextEditingController();
  TextEditingController num_reward = TextEditingController();

  @override
  State<AddMission2> createState() => _AddMission2State();
}

class _AddMission2State extends State<AddMission2> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  final formKey = GlobalKey<ScaffoldState>();
  var value_category;
  var value_trash;

  @override
  Widget build(BuildContext context) {
    //================================================================================================================
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO 1.1 Head Type
          Text("ของรางวัล", style: Roboto14_B_black),
          const SizedBox(height: 5.0),

          //TODO 1.2 Choice Reward
          Row(
            children: [
              _buildChoice(
                  state: "Token", iconEZ: Icons.monetization_on_outlined),
              const SizedBox(width: 10.0),
              _buildChoice(state: "Exp", iconEZ: FontAwesomeIcons.leaf),
            ],
          ),
          const SizedBox(height: 25.0),

          //TODO 2.Input Number of Reward
          TextFormField(
            controller: widget.num_reward,
            obscureText: false,
            style: Roboto14_black,
            keyboardType: TextInputType.number,
            decoration: styleTextFieldMission(
              'Reward',
              'จำนวนของรางวัล',
            ),
          ),
        ],
      ),
    );
  }

  //===============================================================================================================
//TODO 1: Choice Type
  Widget _buildChoice({state, iconEZ}) {
    return ChoiceChip(
      label: Text(
        state,
        style:
            (widget.reward.text == state) ? Roboto14_B_white : Roboto14_B_black,
      ),
      avatar: Icon(
        iconEZ,
        color: (widget.reward.text == state) ? Colors.white : Colors.black,
        size: (state == 'Exp') ? 15 : 20,
      ),
      backgroundColor: Colors.white,
      disabledColor: Colors.white,
      selectedColor: const Color(0xFF00883C),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      elevation: 2,
      selected: (widget.reward.text == state ? true : false),
      onSelected: (value) {
        setState(() {
          widget.reward.text = state;
        });
      },
    );
  }
}
