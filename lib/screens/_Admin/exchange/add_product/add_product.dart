import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/detail.dart';

class Admin_AddProduct extends StatefulWidget {
  const Admin_AddProduct({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_AddProduct";

  @override
  State<Admin_AddProduct> createState() => _Admin_AddProductState();
}

class _Admin_AddProductState extends State<Admin_AddProduct> {
  //index หน้าจอ
  int _activeStepIndex = 0;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();

  List<Step> stepList() => [
        Step(
          isActive: _activeStepIndex >= 0,
          state:
              (_activeStepIndex <= 0) ? StepState.indexed : StepState.complete,
          title: Text("Description", style: Roboto14_B_black),
          content: AddProduct_detail(name: name),
          // content: const Center(child: Text("ชื่อสินค้า")),
        ),
        Step(
          isActive: _activeStepIndex >= 1,
          state:
              (_activeStepIndex <= 1) ? StepState.indexed : StepState.complete,
          title: const Text("Product"),
          content: const Center(child: Text("รูปภาพ")),
        ),
        Step(
          isActive: _activeStepIndex >= 2,
          state:
              (_activeStepIndex <= 2) ? StepState.indexed : StepState.complete,
          title: const Text("Confrim"),
          content: Container(
            child: Column(
              children: [
                Text("Name: ${name.text}"),
              ],
            ),
          ),
          // content: const Center(child: Text("ราคา")),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    //=================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Theme(
          data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF00883C),
                ),
          ),
          child: Stepper(
            steps: stepList(),
            type: StepperType.horizontal,
            currentStep: _activeStepIndex,
            // onStepContinue: () {
            //   //เมื่อไปหน้าต่อไป ต้องให้ currentIndex เพิ่มตามด้วย
            //   if (_activeStepIndex < (stepList().length - 1)) {
            //     _activeStepIndex += 1;
            //   }
            //   setState(() {});
            // },
            // onStepCancel: () {
            //   //ป้องกัน index ทะลุเกิน 0 (-1,-2)
            //   if (_activeStepIndex == 0) {
            //     return;
            //   }
            //   _activeStepIndex -= 1;
            //   setState(() {});
            // },
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Next", style: Roboto16_B_white),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20.0),
                    TextButton(
                      onPressed: () {},
                      child: Text("Cancle", style: Roboto16_B_gray),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
