import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';

class CardMemberStatus extends StatelessWidget {
  const CardMemberStatus({
    Key? key,
    required this.title,
    required this.status,
  }) : super(key: key);

  final title;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //TODO 1. Status Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            //Ture = สีเขียว , False = สีขาว
            color: status ? const Color(0xFF26A45D) : Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          //TODO 2. Icon ที่จะแสดงออกไป
          child: _buildIcon(title, status),
        ),
        const SizedBox(height: 5.0),

        //TODO 3. Title Text
        Text(title, style: Roboto12_B_black),
      ],
    );
  }
}

//================================================================================================
Widget _buildIcon(String title, bool status) {
  if (title == "Member") {
    return Icon(
      Icons.people_outlined,
      size: 50,
      color: status ? Colors.white : const Color(0xFF8C8B8B),
    );
  } else if (title == "Sponsor") {
    return Icon(
      Icons.people_outlined,
      size: 50,
      color: status ? Colors.white : const Color(0xFF8C8B8B),
    );
  } else if (title == "Admin") {
    return Icon(
      Icons.people_outlined,
      size: 50,
      color: status ? Colors.white : const Color(0xFF8C8B8B),
    );
  } else if (title == "ยืนยันตัวตน") {
    return Icon(
      Icons.check_circle_outlined,
      size: 50,
      color: status ? Colors.white : const Color(0xFF8C8B8B),
    );
  } else if (title == "Wallet Conent") {
    return Icon(
      Icons.account_balance_wallet_rounded,
      size: 50,
      color: status ? Colors.white : const Color(0xFF8C8B8B),
    );
  } else {
    return Icon(
      Icons.account_balance_wallet_rounded,
      size: 50,
      color: status ? Colors.white : const Color(0xFF8C8B8B),
    );
  }
}
