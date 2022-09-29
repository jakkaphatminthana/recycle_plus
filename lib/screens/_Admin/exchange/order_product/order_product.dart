import 'package:flutter/material.dart';
import '../../../../components/font.dart';
import '1_delivery/order1_delivery.dart';
import '2_pickup/order2_pickup.dart';

class Admin_ExchangeOrder extends StatefulWidget {
  const Admin_ExchangeOrder({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_ExchangeOrder";

  @override
  State<Admin_ExchangeOrder> createState() => _Admin_ExchangeOrderState();
}

class _Admin_ExchangeOrderState extends State<Admin_ExchangeOrder> {
  //TODO 1. Set Tabbar list here
  TabBar get _tabbar {
    return const TabBar(
      labelColor: Colors.white,
      labelStyle: TextStyle(fontSize: 15),
      unselectedLabelColor: Color(0xFFDFDFDF),
      indicatorWeight: 2,
      indicatorColor: Colors.white,
      //labelPadding: EdgeInsets.only(top: 10.0),
      tabs: [
        Tab(text: 'รถขนส่ง'),
        Tab(text: 'รับสินค้าเอง'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //===================================================================================================================
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("รายการแลกชองรางวัล", style: Roboto16_B_white),
          //TODO 3. Tabbar in Appbar
          bottom: PreferredSize(
            preferredSize: _tabbar.preferredSize,
            child: ColoredBox(
              color: const Color(0xFF15924C),
              child: Container(
                height: 45,
                child: _tabbar,
              ),
            ),
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(), //ไม่ต้องเลื่อนได้,
          children: [
            Order1_productDelivery(),
            Order2_productPickup(),
          ],
        ),
      ),
    );
  }
}
