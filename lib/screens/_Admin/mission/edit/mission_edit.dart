import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/textfield_mission.dart';
import 'package:recycle_plus/screens/_Admin/mission/edit/dialog_missionDelete.dart';
import 'package:recycle_plus/screens/_Admin/mission/edit/dialog_missionEdit.dart';
import 'package:recycle_plus/service/database.dart';

class Admin_MissionEdit extends StatefulWidget {
  const Admin_MissionEdit({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<Admin_MissionEdit> createState() => _Admin_MissionEditState();
}

class _Admin_MissionEditState extends State<Admin_MissionEdit> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  final CategoryList = ["Login", "Recycle", "Trash"];
  final TrashList = ["PETE", "LDPE", "PP"];

  TextEditingController TC_category = TextEditingController();
  TextEditingController TC_title = TextEditingController();
  TextEditingController TC_num_finish = TextEditingController();
  TextEditingController TC_reward = TextEditingController();
  TextEditingController TC_num_reward = TextEditingController();
  TextEditingController TC_trash = TextEditingController();

  //new value
  String? value_category;
  String? value_title;
  String? value_num_finish;
  String? value_reward;
  String? value_num_reward;
  String? value_trash;

  //TODO : เมื่อกด Option
  onChangeCategory({String? mission, String? selectTrash}) async {
    setState(() {
      if (mission == "Trash") {
        value_category = mission;
        value_trash = selectTrash;
      } else {
        value_category = mission;
        value_trash = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var missionType = widget.data!.get("mission");
    var categoryFB = widget.data!.get("category");
    var titleFB = widget.data!.get("title");
    var num_finishFB = widget.data!.get("num_finish");
    var rewardFB = widget.data!.get("reward");
    var num_rewardFB = widget.data!.get("num_reward");
    var trashFB = widget.data!.get("trash");

    //กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
    TC_title = (value_title == null)
        ? TextEditingController(text: titleFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_title); //ค่าที่กำลังป้อน
    TC_num_finish = (value_num_finish == null)
        ? TextEditingController(text: '$num_finishFB') //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_num_finish); //ค่าที่กำลังป้อน
    TC_num_reward = (value_num_reward == null)
        ? TextEditingController(text: '$num_rewardFB') //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_num_reward); //ค่าที่กำลังป้อน

    //============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        //TODO 1. Appbar header
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("แก้ไขภารกิจ", style: Roboto16_B_white),
          actions: [
            //TODO 1.1 Save Icon
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 33,
              ),
              onPressed: () async {
                //TODO : Update on Firebase <<----------------------------------
                if (_formKey.currentState!.validate()) {
                  //สั่งประมวลผลข้อมูลที่กรอก
                  _formKey.currentState?.save();

                  //ตรวจสอบค่าว่าง ของพวก Trash
                  if (value_category == 'Trash' && value_trash == null) {
                    Fluttertoast.showToast(
                      msg: "กรุณาป้อนข้อมูลให้ครบถ้วน",
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    //ปรับค่าให้เป็นข้อมูลเดิม เนื่องจากไม่ได้ไปแก้ไขอะไร
                    setState(() {
                      (value_category == null)
                          ? value_category = categoryFB
                          : value_category;
                      (value_reward == null)
                          ? value_reward = "$rewardFB"
                          : value_reward;
                      (value_category == 'Trash' && value_trash == null)
                          ? value_trash = trashFB
                          : value_trash;
                    });

                    await showDialogMissionEdit(
                      context: context,
                      mission_ID: widget.data.id,
                      missionType: missionType,
                      category: value_category,
                      title: value_title,
                      num_finish: value_num_finish,
                      reward: value_reward,
                      num_reward: value_num_reward,
                      trash: value_trash,
                    );
                    // print('value_category = $value_category');
                    // print('value_title = $value_title');
                    // print('value_num_finish = $value_num_finish');
                    // print('value_reward = $value_reward');
                    // print('value_num_reward = $value_num_reward');
                    // print('value_trash = $value_trash');
                    // print('trashFB = $trashFB');
                    // print('--------------');

                  }
                }
              },
            ),

            //TODO 1.2 Delete Icon
            IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                showDialogMission_Delete(
                  context: context,
                  mission_ID: widget.data.id,
                  missionType: missionType,
                );
              },
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //TODO 2.Mission Head
                        Text("1.ข้อมูลภารกิจ", style: Roboto16_B_black),
                        const SizedBox(height: 15.0),

                        //TODO 2.1 Head Category
                        Text("ประเภทภารกิจ", style: Roboto14_B_green),
                        const SizedBox(height: 5.0),

                        //TODO 2.2 Category Option
                        _build_Option(
                          hint: (value_category == null)
                              ? categoryFB
                              : value_category,
                          listEZ: CategoryList,
                          listShow: _build_CategoryDescription,
                          onChangeOption: onChangeCategory,
                        ),

                        //TODO 2.3 Trash Option
                        //1.กรณีที่ ตอนแรกเป็นแบบ Trash อยู่แล้ว
                        (categoryFB == 'Trash' && value_category == null)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: _build_Option(
                                  hint: (value_trash == null)
                                      ? trashFB
                                      : value_trash,
                                  listEZ: TrashList,
                                  onChangeOption: onChangeCategory,
                                ),
                              )
                            //2. กรณีที่เปลี่ยนเป็นบบ Trash
                            : (value_category == 'Trash')
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: _build_Option(
                                      hint: (value_trash == null)
                                          ? 'เลือกประเภทขยะ'
                                          : value_trash,
                                      listEZ: TrashList,
                                      onChangeOption: onChangeCategory,
                                    ),
                                  )
                                : Container(),
                        const SizedBox(height: 20.0),

                        //TODO 3: Title Mission
                        TextFormField(
                          controller: TC_title,
                          obscureText: false,
                          style: Roboto14_black,
                          maxLength: 15,
                          decoration: styleTextFieldMission(
                            'Title Mission',
                            'หัวข้อที่ต้องการแสดง',
                          ),
                          onSaved: (value) => value_title = value,
                          onChanged: (value) => value_title = value,
                        ),
                        const SizedBox(height: 20.0),

                        //TODO 4: Number to Finish
                        TextFormField(
                          controller: TC_num_finish,
                          obscureText: false,
                          style: Roboto14_black,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: styleTextFieldMission(
                            'Number to finish',
                            'จำนวนสะสมเพื่อให้ภารกิจเสร็จ',
                          ),
                          onSaved: (value) => value_num_finish = value,
                          onChanged: (value) => value_num_finish = value,
                        ),
                        const SizedBox(height: 50.0),

                        //TODO 5.1 Reward Header
                        Text("2.ของรางวัล", style: Roboto16_B_black),
                        const SizedBox(height: 5.0),

                        //TODO 5.2 Choice Reward
                        Row(
                          children: [
                            _buildChoice(
                              state: "Token",
                              iconEZ: Icons.monetization_on_outlined,
                              dataEZ: (value_reward == null)
                                  ? rewardFB
                                  : value_reward,
                            ),
                            const SizedBox(width: 10.0),
                            _buildChoice(
                              state: "Exp",
                              iconEZ: FontAwesomeIcons.leaf,
                              dataEZ: (value_reward == null)
                                  ? rewardFB
                                  : value_reward,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        //TODO 6:  Number of Reward
                        TextFormField(
                          controller: TC_num_reward,
                          obscureText: false,
                          style: Roboto14_black,
                          keyboardType: TextInputType.number,
                          decoration: styleTextFieldMission(
                            'Reward',
                            'จำนวนของรางวัล',
                          ),
                          onSaved: (value) => value_num_reward = value,
                          onChanged: (value) => value_num_reward = value,
                        ),
                      ],
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

  //================================================================================================================
  //TODO 1: Choice Type
  Widget _buildChoice({state, iconEZ, dataEZ}) {
    return ChoiceChip(
      label: Text(
        state,
        style: (dataEZ == state) ? Roboto14_B_white : Roboto14_B_black,
      ),
      avatar: Icon(
        iconEZ,
        color: (dataEZ == state) ? Colors.white : Colors.black,
        size: (state == 'Exp') ? 15 : 20,
      ),
      backgroundColor: Colors.white,
      disabledColor: Colors.white,
      selectedColor: const Color(0xFF00883C),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      elevation: 2,
      selected: (dataEZ == state ? true : false),
      onSelected: (value) {
        setState(() {
          value_reward = state;
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

  //TODO 3: Option Category Select
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
