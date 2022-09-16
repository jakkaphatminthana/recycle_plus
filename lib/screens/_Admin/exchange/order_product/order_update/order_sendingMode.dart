import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';

class Order_sendingMode extends StatelessWidget {
  const Order_sendingMode({
    Key? key,
    required this.order_transport,
    required this.order_tracking,
  }) : super(key: key);
  final order_transport;
  final order_tracking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        Text('เกี่ยวกับพัสดุ', style: Roboto16_B_black),
        const SizedBox(height: 10.0),
        TextRowIcon(
          FontAwesomeIcons.solidBuilding,
          'บริษัทขนส่ง: ',
          order_transport,
        ),
        const SizedBox(height: 5.0),
        TextRowIcon(
          FontAwesomeIcons.box,
          'เลขพัสดุ: ',
          order_tracking,
        ),
        const SizedBox(height: 25.0),
      ],
    );
  }

  //=================================================================================================================
  Widget TextRowIcon(IconEZ, title, value) {
    return Row(
      children: [
        FaIcon(
          IconEZ,
          color: const Color(0xFF30AE68),
          size: 25,
        ),
        const SizedBox(width: 5.0),
        Text(title, style: Roboto14_B_green),
        Text(value, style: Roboto14_black),
      ],
    );
  }
}
