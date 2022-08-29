import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:neo_wallet/shared_preferences/shared_preferences.dart';
import 'package:neo_wallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Logo(title: 'N.E.O'),
                ),
                _Form(),
                Labels(
                    route: 'register',
                    title: '¿No tienes cuenta?',
                    subTitle: 'Registrarse ahora')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final prefs = UserPreferences();

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  late String tokenDeviceId;
  late FirebaseMessaging messaging;

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((token) {
      tokenDeviceId = token!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    /* final socketService = Provider.of<SocketService>(context, listen: false); */

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email,
            placeholder: "Ingrese su Email",
            isPassword: false,
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl..text = prefs.loginEmail,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.text,
            textController: passCtrl,
            isPassword: true,
          ),
          FatButton(
            title: !authService.autenticando
                ? Text('Ingresar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ))
                : CircularProgressIndicator(),
            onPressed: authService.autenticando
                ? null
                : () async {
                    prefs.loginEmail = this.emailCtrl.text;
                    FocusScope.of(context).unfocus();
                    // print(emailCtrl.text);
                    // print(passCtrl.text);

                    final loginOk = await authService.login(
                        emailCtrl.text.trim().toLowerCase(),
                        passCtrl.text.trim(),
                        this.tokenDeviceId);
                    if (loginOk) {
                      /* socketService.connect(); */
                      if (authService.usuario.activated) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        Navigator.pushNamed(context, 'verifyAccount');
                      }
                      /* Navigator.pushReplacementNamed(context, 'home'); */
                    } else {
                      //crear alerta
                      mostrarAlerta(context, 'Login incorrecto',
                          'Revise sus credenciales nuevamente');
                    }
                  },
          ),
        ],
      ),
    );
  }
}
