import 'package:flutter/material.dart';
import 'package:neo_wallet/services/socket_service.dart';

import 'package:provider/provider.dart';

import 'package:neo_wallet/navigation/bottom_navigation.dart';
import 'package:neo_wallet/pages/auth_pages/login_page.dart';
import 'package:neo_wallet/services/auth_services.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: FittedBox(
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Cargando ...',
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggenIn();
    final socketService = Provider.of<SocketService>(context, listen: false);

    if (autenticado) {
      socketService.connect();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => BottomNavigation(),
          transitionDuration: Duration(milliseconds: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0),
        ),
      );
    }
  }
}
