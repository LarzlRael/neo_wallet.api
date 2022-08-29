import 'package:flutter/material.dart';

import 'package:neo_wallet/models/wallets_users_response.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:neo_wallet/services/wallet_services.dart';
import 'package:neo_wallet/utils/utils.dart';
import 'package:neo_wallet/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserWalletSelect extends StatefulWidget {
  @override
  _UserWalletSelectState createState() => _UserWalletSelectState();
}

class _UserWalletSelectState extends State<UserWalletSelect> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late AuthService authService;
  late WalletServices walletServices;

  @override
  Widget build(BuildContext context) {
    walletServices = WalletServices();
    authService = Provider.of<AuthService>(context);

    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.name),
        centerTitle: true,
      ),
      body: Container(
        /* padding: EdgeInsets.all(15), */
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: this.authService.userWallets.length == 0
                  ? NoInformation(
                      icon: Icons.no_accounts,
                      message: 'No tienes billeteras',
                      showButton: true,
                      buttonTitle: 'Crear Nueva Billetera',
                      iconButton: Icons.plus_one,
                      onPressed: () => {
                        Navigator.pushNamed(
                          context,
                          'newWallet',
                          arguments: 'managament_page',
                        )
                      },
                    )
                  : SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _refreshWallets,
                      child: _createListWallets(this.authService.userWallets)),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide.none)),
              child: ListTile(
                leading: Icon(Icons.keyboard_tab_sharp),
                title: Text('Show Backup Phars'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _createListWallets(List<UserWallet> userWallets) {
    return ListView.builder(
      itemCount: userWallets.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int i) {
        return _createWallet(userWallets[i]);
      },
    );
  }

  Container _createWallet(UserWallet wallet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        /* border: Border.all(color: Color(0xff1B242D)), */
        color: Color(0xff212B37),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1.5),
          )
        ],
      ),
      child: ListTile(
        title: Text(wallet.walletName),
        subtitle: Text('${wallet.balance}'),
        trailing: Icon(Icons.edit),
        onTap: () {
          if (wallet.balance > 0) {
            Navigator.pushNamed(context, 'sendPage', arguments: wallet);
          } else {
            showSnackBarNotification(
                context: context,
                message: 'Esta billera no tiene saldo',
                color: Colors.red);
          }
        },
      ),
    );
  }

  void _refreshWallets() async {
    this.authService.userWallets = await this.walletServices.getUsersWallets();
    await Future.delayed(Duration(milliseconds: 1000));
  }
}
