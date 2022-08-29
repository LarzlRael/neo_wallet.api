import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:neo_wallet/models/usuario.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:neo_wallet/services/mail_services.dart';
import 'package:neo_wallet/services/socket_service.dart';
import 'package:neo_wallet/utils/utils.dart';
import 'package:provider/provider.dart';

class VerifyAccount extends StatefulWidget {
  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  late MailServices mailServices;
  late AuthService authService;
  late SocketService socketService;
  late Usuario usuario;

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    usuario = authService.usuario;
    mailServices = MailServices();

    /* mailServices.sendEmailVerification(authService.usuario.email); */

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            /* crossAxisAlignment: CrossAxisAlignment.start, */
            children: [
              Center(
                  child: Icon(
                Ionicons.mail_open_outline,
                color: Colors.blue,
                size: 200,
              )),
              Text(
                'Verifica tu cuenta',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '${usuario.email}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Text(
                  'Por favor complete su verificacion de identidad de correo electronico, acabamos de enviarle un email a su cuenta '),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  sendEmailVerication(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Ionicons.chevron_forward_circle,
                        size: 35,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Reenviar e-mail de verificación',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  await this.authService.isLoggenIn();
                  if (this.authService.usuario.activated) {
                    Navigator.pushReplacementNamed(context, 'home');
                  } else {
                    showSnackBarNotification(
                        color: Colors.red,
                        message: 'Por favor verifica tu email',
                        context: context);
                  }
                },
                child: Text('Ya verifique mi cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendEmailVerication(BuildContext context) {
    this.mailServices.sendEmailVerification(authService.usuario.email);
    showSnackBarNotification(
        color: Colors.green,
        message: 'Correo electronico enviado, verifique su email',
        context: context);
    /* Navigator.pop(context); */
  }
}
