import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:neo_wallet/widgets/widgets.dart';

String toCapitalize(String world) {
  // return '${world[0].toUpperCase()${s.substring(1)} }';
  if (world.length == 0) return '';
  return '${world[0].toUpperCase()}${world.substring(1)}';
}

void showSnackBarNotification({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Text(message,
        style: TextStyle(
          color: Colors.white,
        )),
    action: SnackBarAction(
      label: 'ok',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String? createDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  required VoidCallback onPressed,
}) {
  final nameWallet = TextEditingController();

  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xff25313F),
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.all(10),
        buttonPadding: EdgeInsets.zero,
        title: Center(child: Text(title)),
        content: Container(
          height: 170,
          child: (Column(
            children: [
              Text(subtitle, style: TextStyle(fontWeight: FontWeight.w300)),
              SizedBox(height: 15),
              CustomInput(
                icon: Ionicons.wallet,
                placeholder: 'Nombre de billetera',
                textController: nameWallet,
              ),
              SizedBox(height: 20),
              FatButton(
                  title: Text('Guardar'), onPressed: () => {nameWallet.text}),
            ],
          )),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff212B37),
              ),
              child: Center(child: Text('Cancelar')),
            ),
          ),
        ],
      ),
    );
  }
}

String convertDateTimeToString(DateTime datetime, bool viewDatime) {
  String time = '${datetime.day}/${datetime.month}/${datetime.year}';

  if (viewDatime) {
    return time + '${datetime.hour}:${datetime.minute}';
  } else {
    return time;
  }
}

bool validateEmail(String email) {
  return !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
