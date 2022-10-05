import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/textfield_mission.dart';

class AddMission1 extends StatefulWidget {
  AddMission1({
    Key? key,
    required this.typeMission,
    required this.category,
    required this.title,
    required this.num_finish,
    required this.trash,
  }) : super(key: key);

  TextEditingController typeMission = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController num_finish = TextEditingController();
  TextEditingController trash = TextEditingController();

  @override
  State<AddMission1> createState() => _AddMission1State();
}

class _AddMission1State extends State<AddMission1> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  final formKey = GlobalKey<ScaffoldState>();
  var value_category;
  var value_trash;
  final CategoryList = ["Login", "Recycle", "Trash"];
  final TrashList = ["PETE", "LDPE", "PP"];

  //TODO : เมื่อกด Option
  onChangeCategory({String? mission, String? selectTrash}) async {
    setState(() {
      if (mission == "Trash") {
        widget.category.text = mission!;
        widget.trash.text = selectTrash!;
      } else {
        widget.category.text = mission!;
        widget.trash.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //=================================================================================================================
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO 1.1 Head Type
          Text("เลือกภารกิจ", style: Roboto14_B_black),
          const SizedBox(height: 5.0),

          //TODO 1.2 Choice type
          Row(
            children: [
              _buildChoice(state: "Daily", iconEZ: Icons.filter_1),
              const SizedBox(width: 10.0),
              _buildChoice(state: "Weekly", iconEZ: Icons.filter_7),
            ],
          ),
          const SizedBox(height: 25.0),

          //TODO 2.1 Head Category
          Text("ประเภทภารกิจ", style: Roboto14_B_black),
          const SizedBox(height: 5.0),

          //TODO 2.2 Category Option
          _build_Option(
            hint: "เลือกประเภทภารกิจ",
            listEZ: CategoryList,
            listShow: _build_CategoryDescription,
            onChangeOption: onChangeCategory,
          ),

          //TODO 2.3 กรณีที่ภารกิจแบบ Trash
          (value_category != "Trash")
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _build_Option(
                    hint: "เลือกประเภทขยะ",
                    listEZ: TrashList,
                    onChangeOption: onChangeCategory,
                  ),
                ),
          const SizedBox(height: 25.0),

          //TODO 3. Input Title
          TextFormField(
            controller: widget.title,
            obscureText: false,
            style: Roboto14_black,
            maxLength: 15,
            decoration: styleTextFieldMission(
              'Title Mission',
              'หัวข้อที่ต้องการแสดง',
            ),
          ),
          const SizedBox(height: 20.0),

          //TODO 4.Input Number to Finish
          TextFormField(
            controller: widget.num_finish,
            obscureText: false,
            style: Roboto14_black,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: styleTextFieldMission(
              'Number to finish',
              'จำนวนสะสมเพื่อให้ภารกิจเสร็จ',
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  //================================================================================================================
  //TODO 1: Choice Type
  Widget _buildChoice({state, iconEZ}) {
    return ChoiceChip(
      label: Text(
        state,
        style: (widget.typeMission.text == state)
            ? Roboto14_B_white
            : Roboto14_B_black,
      ),
      avatar: Icon(
        iconEZ,
        color: (widget.typeMission.text == state) ? Colors.white : Colors.black,
      ),
      backgroundColor: Colors.white,
      disabledColor: Colors.white,
      selectedColor: const Color(0xFF00883C),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      elevation: 2,
      selected: (widget.typeMission.text == state ? true : false),
      onSelected: (value) {
        setState(() {
          widget.typeMission.text = state;
        });
      },
    );
  }

  //TODO 2: Option Dropdown
  Widget _build_Option({
    hint,
    List<String>? listEZ,
    Function? listShow,
    Function? onChangeOption,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: //ลบเส้นออกใต้ออก
          DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          //ทำให้แสดงข้อมูลที่ตั้งไว้
          hint: Text(hint),
          style: Roboto14_black,
          value: (listShow != null) ? value_category : value_trash,
          isExpanded: true, //ทำให้กว้าง
          //รายการที่กดเลือกได้
          items: listEZ
              ?.map(
                (value) => DropdownMenuItem(
                  value: value,
                  //กรณีที่อยากให้มี คำอธิบายด้านหลังก็ใส่ function มา
                  child: (listShow != null) ? listShow(value) : Text(value),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              //1. กรณีที่เป็นภารกิจ Trash
              if (listShow == null) {
                value_trash = value;
                onChangeOption!(mission: 'Trash', selectTrash: value);
                //2. กรณีที่เป็นภารกิจแบบ Recycle, Login
              } else {
                value_category = value;
                onChangeOption!(mission: value);
              }
            });
            print("valueEZ = ${value}");
          },
        ),
      ),
    );
  }

  //TODO 2: Option Category Select
  _build_CategoryDescription(option) {
    String? title;
    String? subtitle;

    if (option == 'Login') {
      title = 'Login';
      subtitle = 'การเข้าสู่ระบบ';
    } else if (option == 'Recycle') {
      title = 'Recycle';
      subtitle = 'จำนวนครั้งของการรีไซเคิลขยะ';
    } else if (option == 'Trash') {
      title = 'Trash';
      subtitle = 'จำนวนขยะโดยแยกประเภท';
    } else {
      title = option;
      subtitle = '';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title!),
        Text(subtitle, style: Roboto14_gray),
      ],
    );
  }
}
