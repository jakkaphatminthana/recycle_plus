import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/achievement/dialog_detail.dart';

class CardHonor extends StatefulWidget {
  const CardHonor({
    Key? key,
    required this.image,
    required this.category,
    required this.title,
    required this.description,
    required this.num_now,
    required this.num_finish,
    required this.trash,
  }) : super(key: key);
  final image;
  final category;
  final title;
  final description;
  final num_now;
  final num_finish;
  final trash;

  @override
  State<CardHonor> createState() => _CardHonorState();
}

class _CardHonorState extends State<CardHonor> {
  String? category_quest;
  String? unit;

  //TODO 1: Set value คำอธิบายคร่าวๆ
  Future<void> SetValue() async {
    if (widget.category == "Login") {
      category_quest = "เช็คอินสะสม";
      unit = ' วัน';
    } else if (widget.category == "Recycle") {
      category_quest = "รีไซเคิลขยะ";
      unit = ' ครั้ง';
    } else if (widget.category == "Trash") {
      category_quest = "รีไซเคิล ${widget.trash}";
      unit = " ชิ้น";
    } else if (widget.category == "Level") {
      category_quest = "ระดับเลเวลถึง Lv.";
      unit = "";
    } else {
      category_quest = "ผิดพลาด";
      unit = "";
    }
  }

  

  //TODO 0: First call whenever run
  @override
  void initState() {
    super.initState();
    SetValue();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = ((widget.num_now / widget.num_finish) * 41) / 100;
    final detail_quest = '$category_quest ${widget.num_finish}${unit}';
    //=============================================================================================================
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 100,
        height: 130,
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
              GestureDetector(
                //TODO 2.1: Model Filtered Image Black&White
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix(
                    <double>[
                      0.2126,0.7152,0.0722,0,
                      0,0.2126,0.7152,0.0722, 
                      0,0,0.2126,0.7152,
                      0.0722,0,0,0,
                      0,0,1,0,
                    ],
                  ),
                  child: Image.network(
                    widget.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                //ดูลายละเอียดรูปภาพ
                onTap: () => showDialogAchiDetail(
                  context: context,
                  image: widget.image,
                  title: widget.title,
                  detail: detail_quest,
                  description: widget.description,
                ),
              ),

              const SizedBox(height: 5.0),

              //TODO 4: quest Text
              Text(detail_quest, style: Roboto14_B_white),
              const SizedBox(height: 5.0),

              //TODO 5: LoadingBar
              Stack(
                children: [
                  build_qusetBar(color: const Color(0xFF522304), width: 0.41),
                  build_qusetBar(
                      color: const Color(0xFFF0CB6A), width: percent),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  //=============================================================================================================
  //TODO : Mission Bar
  Widget build_qusetBar({color, width}) {
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
}
