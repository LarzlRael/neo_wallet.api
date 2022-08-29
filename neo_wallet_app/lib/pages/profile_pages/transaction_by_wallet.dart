import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:neo_wallet/helpers/helpers.dart';
import 'package:neo_wallet/models/transactions_response.dart';
import 'package:neo_wallet/models/wallets_users_response.dart';
import 'package:neo_wallet/services/transactions_services.dart';
import 'package:neo_wallet/services/wallet_services.dart';

import 'package:neo_wallet/utils/utils.dart';

import 'package:neo_wallet/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TransactionByWallet extends StatefulWidget {
  @override
  _TransactionByWalletState createState() => _TransactionByWalletState();
}

class _TransactionByWalletState extends State<TransactionByWallet> {
  late TransactionsServices transactionsServices;
  late WalletServices walletServices;
  late String newName;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserWallet;
    transactionsServices = Provider.of<TransactionsServices>(context);
    walletServices = WalletServices();

    return Scaffold(
      appBar: AppBar(
        title: Text(toCapitalize(args.walletName)),
        actions: [
          IconButton(
            onPressed: () => {
              newName = createDialog(
                  context: context,
                  title: 'Editar Nombre',
                  subtitle: 'Nuevo nombre',
                  onPressed: renameWallet(
                    args.id,
                    newName,
                  ))!
            },
            icon: Icon(Ionicons.pencil_sharp),
          ),
          IconButton(
              onPressed: () {
                mostrarAlertaCerrarSesion(
                    context: context,
                    onPressed: () => {deleteWallet(args.id)},
                    title: 'Borrar Billetera',
                    subtitle: '¿Está seguro de borrar esta billetera?');
              },
              icon: Icon(Ionicons.trash)),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            FadeIn(
                duration: Duration(milliseconds: 1000),
                child: WalletCard(
                    amount: args.balance,
                    nameWallet: args.walletName,
                    createdAt: args.createdAt)),
            SizedBox(height: 15),
            Expanded(
              child: FutureBuilder(
                future: transactionsServices.transactionByWallet(args.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<UserTransaction>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length == 0) {
                      return NoInformation(
                          icon: Icons.wallet_giftcard,
                          message: 'Esta billetera no tiene transacciones',
                          showButton: false,
                          iconButton: Icons.ac_unit_outlined);
                    }
                    return TransactionsInfo(userTransaction: snapshot.data!);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteWallet(String idWallet) async {
    final isOk = await this.walletServices.deleteWallet(idWallet);
    if (isOk) {
      Navigator.pop(context, 'route');
      Navigator.pop(context, 'route');
    } else {
      Navigator.pop(context, 'route');

      showSnackBarNotification(
        context: context,
        color: Colors.red,
        message: 'No puedes borrar una billetera con saldo, transfieralo antes',
      );
    }
  }

  renameWallet(String idWallet, String newName) async {
    /* print(newName);
    print(idWallet); */
    /* final isOk = await this.walletServices.renameWallet(idWallet, newName); */
  }
}

 //TODO add image icon and enable to change, show wallets in profile view
 
// TODO Added sockets and fix the rename wallet
//TODO added animation
// TODO added transaction details




 