import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late AuthService authServices;

  File? _image;

  @override
  Widget build(BuildContext context) {
    this.authServices = Provider.of<AuthService>(context);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          _createBackBround(size),
          _loginForm(context),
          Positioned(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                /* color: Colors.amber, */
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        mostrarAlertaCerrarSesion(
                            context: context,
                            onPressed: logOut,
                            title: 'Cerrar Sesion',
                            subtitle: '¿Esta seguro de cerrar sesión?');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _createBackBround(Size size) {
    return Container(
      height: size.height * .35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF06B1FF),
            Color(0xFF0076FE),
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 25.0,
            ),
          ),
          FittedBox(
            child: Container(
              width: size.width * 0.85,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  )
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectGalleryPhoto();
                    },
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 12.0,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 15.0,
                                  color: Color(0xFF404040),
                                ),
                              ),
                            ),
                            radius: 38.0,
                            backgroundImage: this._image == null
                                ? AssetImage('assets/black_logo.png')
                                : Image.file(this._image!).image,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${authServices.usuario.name}',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    '${authServices.usuario.email}',
                    style: TextStyle(fontSize: 15.0, color: Colors.black45),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _createItemProfile(Ionicons.wallet,
                          '${authServices.userWallets.length} Billeteras'),
                      /* _createItemProfile(Ionicons.wallet, '5 billterras'),
                      _createItemProfile(Ionicons.wallet, '5 billterras'), */
                    ],
                  ),
                ],
              ),
            ),
          ),
          /* 
          Spacer(
            child: SingleChildScrollView(
              child: ListView.separated(
                itemCount: this.authServices.userWallets.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return WalletCard(
                    amount: this.authServices.userWallets[index].balance,
                    createdAt: this.authServices.userWallets[index].createdAt,
                    nameWallet: this.authServices.userWallets[index].walletName,
                  );
                },
              ),
            ),
          ), */
        ],
      ),
    );
  }

  Column _createItemProfile(IconData icon, String title) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.black45,
        ),
        SizedBox(height: 5.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void logOut() {
    authServices.logout();
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(context, "login", (r) => false);
  }

  void _selectGalleryPhoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _procesarImagen(ImageSource origen) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: origen,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
