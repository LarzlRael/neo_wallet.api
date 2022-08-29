import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:neo_wallet/helpers/helpers.dart';
import 'package:neo_wallet/models/usuario.dart';
import 'package:neo_wallet/models/wallets_users_response.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:neo_wallet/services/socket_service.dart';
import 'package:neo_wallet/services/transactions_services.dart';
import 'package:neo_wallet/services/wallet_services.dart';
import 'package:neo_wallet/utils/utils.dart';
import 'package:neo_wallet/widgets/wallet_status.dart';
import 'package:neo_wallet/widgets/widgets.dart';
import 'package:clipboard/clipboard.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  //

  TextEditingController walletDirectionToSend = TextEditingController();
  TextEditingController amount = TextEditingController();

  late SocketService socketService;
  late TransactionsServices transactionsServices;

  double _currentSliderValue = 0;

  late UserWallet walletArgument;
  late Usuario usuario;
  late AuthService authService;
  late SnackBar snackBar;
  late WalletServices walletServices;
  @override
  void initState() {
    socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    usuario = authService.usuario;
    walletServices = WalletServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    transactionsServices =
        Provider.of<TransactionsServices>(context, listen: false);

    this.walletArgument =
        ModalRoute.of(context)!.settings.arguments as UserWallet;

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletStatus(
                showButton: false,
                walletHeightSize: 0.25,
              ),
              containerElements(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerElements(BuildContext context) {
    final size = 16.0;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Billetera : ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
              children: <TextSpan>[
                TextSpan(
                  text: '${walletArgument.walletName}',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          SizedBox(height: 3),
          RichText(
            text: TextSpan(
              text: 'Saldo Actual : ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
              children: <TextSpan>[
                TextSpan(
                  text: '${walletArgument.balance}',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          _createInput(walletDirectionToSend, 'Ingrese dirección de recibo',
              TextInputType.text),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonWithIcon(
                icon: Ionicons.qr_code,
                label: 'Scanear',
                buttonBorderPrimary: true,
                onPressed: scanQr,
              ),
              ButtonWithIcon(
                icon: Ionicons.clipboard_outline,
                label: 'Pegar',
                buttonBorderPrimary: false,
                onPressed: pasteValue,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text('Enviar : ${this._currentSliderValue}'),
          _createSlider(walletArgument.balance),
          _createInput(amount, 'Saldo', TextInputType.number),
          _sendButton(context),
        ],
      ),
    );
  }

  Container _createInput(TextEditingController editingController,
      String placeHolder, TextInputType keyboardType) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 20),
      padding: EdgeInsets.only(top: 0, left: 15, bottom: 0, right: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white38),
        borderRadius: BorderRadius.all(Radius.circular(
          25,
        )),
      ),
      child: TextField(
        controller: editingController,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeHolder,
        ),
      ),
    );
  }

  Widget _sendButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: this.transactionsServices.isSending
              ? null
              : () async {
                  await sendAmount();
                },
          child: !this.transactionsServices.isSending
              ? Text('Enviar')
              : CircularProgressIndicator()),
    );
  }

  void scanQr() async {
    /* try {
      StringbarcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", false, ScanMode.DEFAULT);
    } catch (e) {
      barcodeScanRes = e.toString();
    } */
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancelar", false, ScanMode.DEFAULT);

    setState(() {
      this.walletDirectionToSend.text = barcodeScanRes;
    });
  }

  _createSlider(int balance) {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: balance.toDouble(),
      /* divisions: 5, */
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value.ceilToDouble();
          this.amount.text = _currentSliderValue.toString();
        });
      },
    );
  }

  Future sendAmount() async {
    if (this.walletDirectionToSend.text.length == 0) {
      return mostrarAlerta(context, 'Error',
          'Hubo un error en la transaccion, revise la direccion de envio');
    }

    final amountToSend = double.parse(this.amount.text);
    if (amountToSend > this.walletArgument.balance) {
      return mostrarAlerta(
        context,
        'Error',
        'No puedes enviar mas de lo que tienes',
      );
    }

    final respOK = await this.transactionsServices.sendAmountToServer(
          amount: amountToSend.toInt(),
          userOriginWallet: this.walletArgument.id,
          userTargetWallet: this.walletDirectionToSend.text,
          userOriginName: this.usuario.name,
        );
    if (respOK) {
      /* socketService.emit('transaction-real-time', (respOK.newTransactionRaw)); */
      showSnackBarNotification(
          context: context,
          message: 'Enviado correctamente',
          color: Colors.green);
      // update the wallet state
      this.authService.userWallets =
          await this.walletServices.getUsersWallets();
      /*  Navigator.pushNamed(context, 'home'); */
    } else {
      mostrarAlerta(context, 'Error',
          'Hubo un error en la transaccion, revise la direccion de envio');
    }
  }

  void pasteValue() async {
    final value = await FlutterClipboard.paste();
    setState(() {
      this.walletDirectionToSend.text = value.length != 0 ? value : '';
    });
  }
}
