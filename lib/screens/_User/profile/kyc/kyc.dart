import 'package:flutter/material.dart';
import 'package:recycle_plus/models/varidator.dart';

class KYCscreen extends StatefulWidget {
  const KYCscreen({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/KYC";

  @override
  _KYCscreenState createState() => _KYCscreenState();
}

class _KYCscreenState extends State<KYCscreen> {
  TextEditingController? textController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // int textLen = 5;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF107027),
        automaticallyImplyLeading: true,
        title: const Text(
          'โปรดกรอกเลขบัตรประชาชน',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                    child: Text(
                      'ข้อกำหนดและเงื่อนไข',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Text(
                      'แอปพลิเคชันจะเก็บข้อมูลเลขบัตรประจำตัวประชาชนของ\nคุณสําหรับการยืนยันตัวตนเพื่อใช้ในการใช้ฟีเจอร์ต่างๆใน\nแอปพลิเคชัน\n\nหมายเหตุ : หากคุณไม่ได้กดตกลงเพื่อที่จะยืนยันตัวตน\nคุณจะไม่สามารถทำการแลกของรางวัลในแอปพลิเคชัน\nได้ เนื่องจากแอปพลิเคชันจําเป็นต้องพิสูจน์และยืนยัน\nตัวตนของคุณ\n',
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 80,
                      child: TextFormField(
                        validator: ValidatorKYC,
                        maxLength: 13,
                        controller: textController,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: 'กรอกเลขบัตรประชาชน',
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text(
                        'ตกลง',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF107027),
                        fixedSize: const Size(150, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
