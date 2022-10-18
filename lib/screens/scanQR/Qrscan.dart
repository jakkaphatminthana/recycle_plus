import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Sponsor/register_sponsor.dart';
import 'LDPE/LDPE_detail.dart';
import 'PETE/PETE_detail.dart';
import 'PP/PP_detail.dart';

String qrString = 'not scanned';

class QRscanWidget extends StatefulWidget {
  const QRscanWidget({Key? key}) : super(key: key);

  @override
  _QRscanWidgetState createState() => _QRscanWidgetState();
}

class _QRscanWidgetState extends State<QRscanWidget> {
  Future<void> scanQR() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'Cancel', true, ScanMode.QR)
          .then((value) {
        setState(() {
          qrString = value;
        });
        if (qrString == 'Recycle+_PETE') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => PETE_detailWidget()),
            ),
          );
        } else if (qrString == 'Recycle+_LDPE') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => LDPE_detailWidget()),
            ),
          );
        } else if (qrString == 'Recycle+_PP') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => PP_detailWidget()),
            ),
          );
        }
      });
    } catch (e) {
      setState(() {
        qrString = 'unable to read the qr';
      });
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //=============================================================================================================
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 70),
                    child: TextButton(
                      //ปุ่มกดไปหน้าpete
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PETE_detailWidget(),
                          ),
                        );
                      },
                      child: Text('PETE'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 70),
                    child: TextButton(
                      //ปุ่มกดไปหน้าpp
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PP_detailWidget(),
                          ),
                        );
                      },
                      child: Text('PP'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 70),
                    child: TextButton(
                      //ปุ่มกดไปหน้าpp
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LDPE_detailWidget(),
                          ),
                        );
                      },
                      child: Text('LDPE'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 70),
                    child: TextButton(
                      //ปุ่มกดไปหน้าpp
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SponsorRegisterScreen(),
                          ),
                        );
                      },
                      child: Text('Sponsor'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 70),
                    child: TextButton(
                      //ปุ่มกดไปหน้าpp
                      onPressed: scanQR, child: Text('Scan'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
