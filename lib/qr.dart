import 'package:flutter/material.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatelessWidget {
  final String data;
  const QrPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Material(
                color: const Color.fromARGB(255, 207, 227, 230),
                //padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: InkWell(
                  onTap:(){
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    child:Center(
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 36,
                      ),
                     ) 
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: 4,
              child: Center(
                child: QrImageView(
                  data: data,
                  version: QrVersions.auto,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text(loc.showQrcode, style: TextStyle(fontSize: 20)),
                    Image.asset(
                      'assets/show_screen.png',
                      height: screenHeight * 0.2,
                      fit: BoxFit.contain,
                    )
                  ]
                )                  
              )
            ),
          ],
        ),
      ),
    );
  }
}
