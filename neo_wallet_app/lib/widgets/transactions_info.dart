part of 'widgets.dart';

class TransactionsInfo extends StatelessWidget {
  final List<UserTransaction> userTransaction;

  const TransactionsInfo({required this.userTransaction});
  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: Duration(milliseconds: 250),
      child: this.userTransaction.length == 0
          ? NoInformation(
              icon: Ionicons.wallet_sharp,
              message: 'No tienes transacciones',
              showButton: false,
              iconButton: Icons.send,
            )
          : ListView.builder(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              scrollDirection: Axis.vertical,
              itemCount: userTransaction.length,
              itemBuilder: (BuildContext context, int i) =>
                  _createInfoBloc(context, userTransaction[i]),
              /* children: [
                      /* _createInfoBloc(),
                      _createInfoBloc(),
                      _createInfoBloc(), */
                          
                      
                      
                    ], */
            ),
    );
  }

  Widget createTransaction(List<UserTransaction> userTransaction) {
    return ListView.builder(
      padding: EdgeInsets.all(15),
      scrollDirection: Axis.vertical,
      itemCount: userTransaction.length,
      itemBuilder: (BuildContext context, int i) =>
          _createInfoBloc(context, userTransaction[i]),
      /* children: [
                    /* _createInfoBloc(),
                    _createInfoBloc(),
                    _createInfoBloc(), */
                        
                    
                    
                  ], */
    );
  }

  Widget _createInfoBloc(
      BuildContext context, UserTransaction userTransaction) {
    final authService = Provider.of<AuthService>(context);

    final color = Color(0xff7BC896);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xff212B37),
        border: Border.all(width: 0.5, color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    userTransaction.destinyUser != authService.usuario.uid
                        ? Ionicons.arrow_up_circle_sharp
                        : Ionicons.arrow_down_circle_sharp,
                    size: 35,
                    color: color,
                  ),
                  SizedBox(width: 5),
                  Text(
                    userTransaction.destinyUser != authService.usuario.uid
                        ? 'Enviado'
                        : 'Recibido',
                    style: TextStyle(fontSize: 18, color: color),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    /* '01/05/2021, 14:33', */
                    '${userTransaction.createdAt.day}/${userTransaction.createdAt.month}/${userTransaction.createdAt.year}  ${userTransaction.createdAt.hour}:${userTransaction.createdAt.minute}',
                    style: TextStyle(fontSize: 13, color: Colors.white54),
                  ),
                  SizedBox(height: 7),
                  Text(
                    /* '0x1750bab89...4fd626984e0', */
                    '${userTransaction.originUser}',
                    style: TextStyle(fontSize: 13, color: Colors.white54),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.white38,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'transactionDetails');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // amount
                  '${userTransaction.amount} BOBS',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
