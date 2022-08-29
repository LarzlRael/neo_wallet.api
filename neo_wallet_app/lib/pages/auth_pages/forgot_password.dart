import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:neo_wallet/services/mail_services.dart';
import 'package:neo_wallet/utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  String emailField = '';
  late MailServices mailServices;

  @override
  Widget build(BuildContext context) {
    mailServices = MailServices();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              /* crossAxisAlignment: CrossAxisAlignment.start, */
              children: [
                Center(
                    child: Icon(
                  Ionicons.mail_unread,
                  color: Colors.blue,
                  size: 200,
                )),
                Text(
                  'Recuperacion de contraseña',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                    'Vamos a enviar un correo electronico para recuperar su contraseña, siga los pasos por favor.'),
                SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    initialValue: '',
                    decoration:
                        InputDecoration(labelText: 'Correo electronico'),
                    validator: (value) {
                      if (validateEmail(value!)) {
                        return 'Ingrese un correo electronico valido';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => emailField = value!,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _submit();
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
                        'Enviar email de recuperación',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    /* print(this.emailField); */
    final resp = await this.mailServices.forgotPassword(this.emailField);
    if (resp) {
      showSnackBarNotification(
          context: context,
          message: 'Correo enviado, revise su bandeja de entrada',
          color: Colors.green);
      Navigator.pop(context);
    } else {
      showSnackBarNotification(
          context: context,
          message: 'Hubo un error al comprobar su email',
          color: Colors.red);
    }
  }
}
