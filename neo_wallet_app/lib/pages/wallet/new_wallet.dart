import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:neo_wallet/helpers/helpers.dart';
import 'package:neo_wallet/models/wallets_users_response.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:neo_wallet/services/wallet_services.dart';
import 'package:neo_wallet/utils/utils.dart';
import 'package:neo_wallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NewWallet extends StatefulWidget {
  @override
  _NewWalletState createState() => _NewWalletState();
}

class _NewWalletState extends State<NewWallet> {
  late String? from;
  late AuthService authService;

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    this.from = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.from != 'wallet_page'
            ? '${authService.usuario.name}'
            : 'Selecciona una billetera'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: this.authService.userWallets.length == 0
                ? NoInformation(
                    icon: Icons.no_accounts,
                    message: 'No tienes billeteras, pulsa en + para crear una',
                    showButton: false,
                    iconButton: Icons.plus_one,
                    onPressed: () => {},
                  )
                : _createListWallets(this.authService.userWallets),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _createDialog(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  ListView _createListWallets(List<UserWallet> userWallets) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: userWallets.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int i) {
        return _showWallet(context, userWallets[i]);
      },
    );
  }

  Widget _showWallet(BuildContext context, UserWallet userWallet) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'qrPage', arguments: userWallet);
            },
            leading: Icon(Ionicons.wallet),
            title: Text(toCapitalize(userWallet.walletName)),
            subtitle: Text('${userWallet.balance}'),
            trailing: Icon(Icons.qr_code_2_outlined),
          ),
        ),
      ],
    );
  }

  _createDialog(BuildContext context) {
    final nameWallet = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Color(0xff25313F),
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(10),
          buttonPadding: EdgeInsets.zero,
          title: Center(child: Text('${authService.usuario.name}')),
          content: Container(
            height: 170,
            child: (Column(
              children: [
                Text('Nombre de billetera',
                    style: TextStyle(fontWeight: FontWeight.w300)),
                SizedBox(height: 15),
                CustomInput(
                  icon: Ionicons.wallet,
                  placeholder: 'Nombre de billetera',
                  textController: nameWallet,
                ),
                SizedBox(height: 20),
                FatButton(
                  title: Text('Guardar'),
                  onPressed: () => {
                    onSubmitNewWallet(context, nameWallet),
                  },
                ),
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

  onSubmitNewWallet(
      BuildContext context, TextEditingController nameWallet) async {
    final walletService = WalletServices();
    if (nameWallet.text.trim().length > 20) {
      return mostrarAlerta(
          context, 'Error', 'El nombre debe ser menor a 20 caracteres');
    }
    final respOk = await walletService.createNewWallet(nameWallet.text.trim());

    if (respOk) {
      this.authService.userWallets = await walletService.getUsersWallets();
      Navigator.pop(context);
    }
  }
}
