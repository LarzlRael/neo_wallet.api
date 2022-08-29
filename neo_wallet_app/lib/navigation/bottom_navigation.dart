import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:neo_wallet/pages/bottom_navigation/managament_page.dart';
import 'package:neo_wallet/pages/bottom_navigation/user_transactions_history_page.dart';
import 'package:neo_wallet/pages/bottom_navigation/wallet_page.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _callPage(currentIndex),
      bottomNavigationBar: _createNavigatorBar(context),
    );
  }

  _callPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return WalletPage();
      case 1:
        return UserTransactionsHistoryPage();
      /* case 1:
        return ItemsPage(); */

      case 2:
        return ManagamentPage();

      default:
        return WalletPage();
    }
  }

  Widget _createNavigatorBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Color(0xff212B37),
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Ionicons.wallet_outline), label: 'Transacciones'),
        BottomNavigationBarItem(
            icon: Icon(Ionicons.globe_outline), label: 'Articulos'),
        BottomNavigationBarItem(
            icon: Icon(Ionicons.settings_outline), label: 'Administrar'),
      ],
    );
  }
}
