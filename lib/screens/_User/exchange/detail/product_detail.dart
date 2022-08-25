import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/image_full.dart';
import 'package:recycle_plus/service/database.dart';

class Member_ProductDetail extends StatefulWidget {
  const Member_ProductDetail({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<Member_ProductDetail> createState() => _Member_ProductDetailState();
}

class _Member_ProductDetailState extends State<Member_ProductDetail> {
  //db = ติดต่อ firebase
  DatabaseEZ db = DatabaseEZ.instance;
  int _counter = 1;
  var _price_value;

  //TODO : Counter Amount
  void _incrementCounter(token, token_change) {
    setState(() {
      _counter++;
      token_change = token * _counter;
      _price_value = token_change;
      print(token_change);
    });
  }

  void _decrementCounter(token, token_change) {
    setState(() {
      if (_counter > 1) {
        _counter--;
        token_change = (token * (_counter + 1)) - token;
        _price_value = token_change;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _price_value = widget.data!.get('token');
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.data!.get('image');
    final name = widget.data!.get('name');
    final token = widget.data!.get('token');
    final token_change = token;
    final amount = widget.data!.get('amount');
    final description = widget.data!.get('description');
    final pickup = widget.data!.get('pickup');
    final delivery = widget.data!.get('delivery');
    //================================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        title: Text("รายละเอียดสินค้า", style: Roboto16_B_white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 2. Image Product
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageFullScreen(
                            imageNetwork: image,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 240,
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Image.network(
                          image,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 10.0,
                    thickness: 10,
                    color: Color(0xFFC4C4C4),
                  ),

                  //TODO 3. Header Product
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TODO 3.1: Product Name
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Text(name, style: Roboto18_B_black),
                        ),
                        const SizedBox(height: 10.0),

                        //TODO 3.2: Price and amount
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //1.Token
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/image/token.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    "$_price_value",
                                    style: Roboto18_B_green,
                                  ),
                                ],
                              ),

                              //2.Counter
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: const Color(0xFF9E9E9E),
                                      ),
                                    ),
                                    child: build_counter(token, token_change),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  //TODO 4: Amout Product & Status
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F9DD),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Amount
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.box,
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 7.0),
                              Text("$amount ชิ้น", style: Roboto16_B_black),
                            ],
                          ),

                          //Status Product
                          Row(
                            children: [
                              _buildStatusIcon(
                                StatusEZ: pickup,
                                iconEZ: FontAwesomeIcons.store,
                              ),
                              const SizedBox(width: 5.0),
                              _buildStatusIcon(
                                StatusEZ: delivery,
                                iconEZ: FontAwesomeIcons.truck,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: Color(0xFFC4C4C4),
                  ),

                  //TODO 5: Description Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text("รายละเอียดสินค้า", style: Roboto14_B_black),
                  ),

                  //TODO 6: Description Contet
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Text(description, style: Roboto14_black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 7: Button Buy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("แต้มของฉัน : ", style: Roboto16_B_black),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text("1500", style: Roboto16_B_green),
                      )
                    ],
                  ),
                  const SizedBox(height: 5.0),

                  //TODO 8: Button Buy
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text('แลกของรางวัล', style: Roboto18_B_white),
                      ),
                      color: Colors.green,
                      elevation: 2.0,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //=================================================================================================================
  //TODO : Widget Conuter
  Widget build_counter(token, token_change) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Button ลบ
        FloatingActionButton(
          heroTag: 'btn1',
          backgroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightElevation: 0.0,
          hoverElevation: 0.0,
          elevation: 0.0,
          onPressed: () => _decrementCounter(token, token_change),
          child: const Icon(
            Icons.remove,
            size: 30,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 5.0),
        Text("$_counter", style: Roboto14_B_black),
        const SizedBox(width: 5.0),
        //Button บวก
        FloatingActionButton(
          heroTag: 'btn2',
          backgroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightElevation: 0.0,
          hoverElevation: 0.0,
          elevation: 0.0,
          onPressed: () => _incrementCounter(token, token_change),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  //TODO : Icon Status
  Widget _buildStatusIcon({required bool StatusEZ, required IconData iconEZ}) {
    return CircleAvatar(
      backgroundColor:
          (StatusEZ == true) ? const Color(0xFF00883C) : Colors.grey,
      radius: 15,
      child: FaIcon(
        iconEZ,
        size: 15,
        color: (StatusEZ == true) ? Colors.white : Colors.black,
      ),
    );
  }
}
