import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          MaterialButton(
            child: Text('Ok'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(
          child: Text('ok'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

mostrarAlertaCerrarSesion({
  required BuildContext context,
  required String title,
  required String subtitle,
  required VoidCallback onPressed,
}) {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: [
          MaterialButton(
            child: Text('Cancelar'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            child: Text('Si'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text('xd'),
      content: Text('xd'),
      actions: [
        CupertinoDialogAction(
          child: Text('ok'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
