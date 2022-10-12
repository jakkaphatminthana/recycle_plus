import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/add1.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/add2.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/add3.dart';
import 'package:recycle_plus/screens/_Admin/mission/mission.dart';
import 'package:recycle_plus/service/database.dart';

class Admin_AddMission extends StatefulWidget {
  const Admin_AddMission({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_AddMission";

  @override
  State<Admin_AddMission> createState() => _Admin_AddMissionState();
}

class _Admin_AddMissionState extends State<Admin_AddMission> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  //index หน้าจอ
  int _activeStepIndex = 0;

  TextEditingController typeMission = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController num_finish = TextEditingController();
  TextEditingController reward = TextEditingController();
  TextEditingController num_reward = TextEditingController();
  TextEditingController trash = TextEditingController(); //กรณีที่ภารกิจ trash

  //------------------------------------------------------------------------------------------------------------------
  //TODO 1. Stepper
  List<Step> stepList() => [
        //Stepper Page 1
        Step(
          isActive: _activeStepIndex >= 0,
          state:
              (_activeStepIndex <= 0) ? StepState.indexed : StepState.complete,
          title: Text("Mission", style: Roboto14_B_black),
          //TODO 1.1 เนื้อหาในหน้าที่ 1
          content: AddMission1(
            typeMission: typeMission,
            category: category,
            title: title,
            num_finish: num_finish,
            trash: trash,
          ),
        ),
        //------------------------------------------------------<< 2
        //Stepper Page 2
        Step(
          isActive: _activeStepIndex >= 1,
          state:
              (_activeStepIndex <= 1) ? StepState.indexed : StepState.complete,
          title: const Text("Reward"),
          //TODO 1.2 เนื้อหาในหน้าที่ 2
          content: AddMission2(
            reward: reward,
            num_reward: num_reward,
          ),
        ),
        //------------------------------------------------------<< 3
        //Stepper Page 3
        Step(
          isActive: _activeStepIndex >= 2,
          state:
              (_activeStepIndex <= 2) ? StepState.indexed : StepState.complete,
          title: const Text("Confrim"),
          content: AddMission3(
            typeMission: typeMission,
            category: category,
            title: title,
            num_finish: num_finish,
            reward: reward,
            num_reward: num_reward,
            trash: trash,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    //================================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          title: const Text("Add Mission"),
          centerTitle: true,
        ),
        body: SafeArea(
          //TODO 2. กำหนดสีของ หน้าจอ
          child: Theme(
            data: ThemeData(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color(0xFF00883C),
                  ),
            ),
            //TODO 3. Stepper Banner
            child: Stepper(
              steps: stepList(),
              type: StepperType.horizontal,
              currentStep: _activeStepIndex,
              //TODO 4. การกดปุ่ม
              controlsBuilder:
                  (BuildContext context, ControlsDetails controls) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //TODO 5. เมื่อกดปุ่ม Continue
                      ElevatedButton(
                        child: Text("Continue", style: Roboto16_B_white),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(125, 35),
                        ),
                        onPressed: () {
                          //TODO 5.1: หน้าที่ 1 จะไปหน้า 2
                          if (_activeStepIndex == 0) {
                            // print('type: ${typeMission.text}');
                            // print('cate: ${category.text}');
                            // print('title: ${title.text}');
                            // print('num: ${num_finish.text}');
                            // print('trash: ${trash.text}');
                            bool checkTrash = (category.text == 'Trash' &&
                                    trash.text != '')
                                ? true
                                : (category.text != 'Trash' && trash.text == '')
                                    ? true
                                    : false;

                            //ตรวจสอบการป้อนข้อมูล
                            if (typeMission.text != "" &&
                                category.text != "" &&
                                title.text != "" &&
                                num_finish.text != "" &&
                                checkTrash) {
                              //ไปหน้าต่อไป
                              if (_activeStepIndex < (stepList().length - 1)) {
                                _activeStepIndex += 1;
                              }
                              setState(() {});
                              FocusManager.instance.primaryFocus?.unfocus();
                            } else {
                              Fluttertoast.showToast(
                                msg: "กรุณาป้อนข้อมูลให้ครบถ้วน",
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          }

                          //TODO 5.2: หน้าที่ 2 จะไปหน้า 3
                          else if (_activeStepIndex == 1) {
                            print('reward: ${reward.text}');
                            print('num_re: ${num_reward.text}');
                            //ตรวจสอบการป้อนข้อมูล
                            if (reward.text != "" && num_reward.text != "") {
                              //ไปหน้าต่อไป
                              if (_activeStepIndex < (stepList().length - 1)) {
                                _activeStepIndex += 1;
                              }
                              setState(() {});
                              FocusManager.instance.primaryFocus?.unfocus();
                            } else {
                              Fluttertoast.showToast(
                                msg: "กรุณาป้อนข้อมูลให้ครบถ้วน",
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          }

                          //TODO 5.3: หน้าที่ 3
                          else if (_activeStepIndex == 2) {
                            upload_data(
                              typeMission: typeMission.text,
                              category: category.text,
                              title: title.text,
                              num_finish: num_finish.text,
                              reward: reward.text,
                              num_reward: num_reward.text,
                              trash: trash.text,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 10.0),

                      //-------------------------------------------------------------
                      //TODO 6. เมื่อกดปุ่ม Cancle
                      TextButton(
                        child: Text("Cancle", style: Roboto16_B_gray),
                        style: TextButton.styleFrom(
                          fixedSize: const Size(100, 35),
                        ),
                        onPressed: () {
                          //ป้องกัน index ทะลุเกิน 0 (-1,-2)
                          if (_activeStepIndex == 0) {
                            return;
                            //ป้องกันกรอก Trash แล้วกลับไปยังมีค่าอยู่
                          }

                          _activeStepIndex -= 1;
                          setState(() {});
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  //================================================================================================================
  //TODO : Create Mission on Firebase
  Future upload_data({
    required typeMission,
    required category,
    required title,
    required num_finish,
    required reward,
    required num_reward,
    required trash,
  }) async {
    var int_finish = int.parse(num_finish);
    var double_reward = double.parse(num_reward);

    await db
        .createMission(
      typeMission: typeMission,
      category: category,
      title: title,
      num_finish: int_finish,
      reward: reward,
      num_reward: double_reward,
      trash: trash,
    )
        .then((value) {
      print('add mission');
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, Admin_MissionScreen.routeName);
    }).catchError((err) => print('faild mission: $err'));
  }
}
