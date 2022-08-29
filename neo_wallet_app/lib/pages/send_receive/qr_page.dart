import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:neo_wallet/models/wallets_users_response.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:neo_wallet/services/qr_services.dart';
import 'package:neo_wallet/utils/utils.dart';
import 'package:provider/provider.dart';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  late UserWallet args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as UserWallet;

    final qrService = QrService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recibir por medio de QR'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: FutureBuilder(
          future: qrService.getWalletQr(args.id),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return _createQrContainer(context, snapshot);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _createQrContainer(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return FittedBox(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        /* height: MediaQuery.of(context).size.height * 0.5, */
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: Color(0xff212B37),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Text(
              usuario.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              toCapitalize(args.walletName),
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: Image.memory(
                base64Decode(snapshot.data),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                await FlutterClipboard.copy(args.id);

                showSnackBarNotification(
                  message: 'Codigo Copiado',
                  color: Colors.blue,
                  context: context,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Copiar codigo'),
                  Icon(Ionicons.copy),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
