import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class CardHonor extends StatefulWidget {
  const CardHonor({
    Key? key,
    required this.title,
    required this.image,
    required this.num_now,
    required this.num_finish,
    required this.status,
  }) : super(key: key);
  final title;
  final image;
  final num_now;
  final num_finish;
  final status;

  @override
  State<CardHonor> createState() => _CardHonorState();
}

class _CardHonorState extends State<CardHonor> {
  @override
  Widget build(BuildContext context) {
    final percent = ((widget.num_now / widget.num_finish) * 41) / 100;

    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 100,
        height: 100,
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
              const SizedBox(height: 15.0),

              //TODO 3: LoadingBar
              Stack(
                children: [
                  build_qusetBar(color: const Color(0xFF522304), width: 0.41),
                  build_qusetBar(color: const Color(0xFFF0CB6A), width: percent),
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
