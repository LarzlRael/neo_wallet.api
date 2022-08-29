import 'package:flutter/material.dart';
import 'package:neo_wallet/navigation/bottom_navigation.dart';
import 'package:neo_wallet/pages/auth_pages/forgot_password.dart';
import 'package:neo_wallet/pages/loading_page.dart';
import 'package:neo_wallet/pages/auth_pages/login_page.dart';
import 'package:neo_wallet/pages/bottom_navigation/managament_page.dart';
import 'package:neo_wallet/pages/wallet/new_wallet.dart';
import 'package:neo_wallet/pages/send_receive/qr_page.dart';
import 'package:neo_wallet/pages/auth_pages/register_page.dart';
import 'package:neo_wallet/pages/send_receive/send_page.dart';
import 'package:neo_wallet/pages/profile_pages/transaction_by_wallet.dart';
import 'package:neo_wallet/pages/profile_pages/user_profile.dart';
import 'package:neo_wallet/pages/bottom_navigation/user_transactions_history_page.dart';
import 'package:neo_wallet/pages/wallet/users_wallet_select.dart';
import 'package:neo_wallet/pages/auth_pages/verify_account.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  /* Register and login  */
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),

  //? Bottom navigation pages
  'home': (_) => BottomNavigation(),
  'loading': (_) => LoadingPage(),
  'transactionHistory': (_) => UserTransactionsHistoryPage(),

  // ?
  'sendPage': (_) => SendPage(),
  'newWallet': (_) => NewWallet(),
  'qrPage': (_) => QrPage(),
  'usersWallets': (_) => ManagamentPage(),
  'userWalletSelect': (_) => UserWalletSelect(),
  'transactionByWallet': (_) => TransactionByWallet(),

  'userProfile': (_) => UserProfile(),
  'verifyAccount': (_) => VerifyAccount(),
  'forgotPassword': (_) => ForgotPassword(),
};
