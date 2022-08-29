part of 'widgets.dart';

class HistoryUsersTransactions extends StatelessWidget {
  final UserTransaction userTransaction;
  final AnimationController animationController;

  const HistoryUsersTransactions({
    required this.userTransaction,
    required this.animationController,
  });
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final color = Color(0xff7BC896);

    return FadeTransition(
      opacity: this.animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: _transaction(authService, color, context),
      ),
    );
  }

  Container _transaction(
      AuthService authService, Color color, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    Icons.arrow_circle_up,
                    size: 35,
                    color: userTransaction.originUser == authService.usuario.uid
                        ? color
                        : Colors.blue,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Enviado',
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          userTransaction.originUser == authService.usuario.uid
                              ? color
                              : Colors.blue,
                    ),
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
