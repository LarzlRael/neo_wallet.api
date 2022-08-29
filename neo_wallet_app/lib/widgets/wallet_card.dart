part of 'widgets.dart';

class WalletCard extends StatelessWidget {
  final int amount;
  final String nameWallet;
  final DateTime createdAt;
  const WalletCard({
    required this.amount,
    required this.nameWallet,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context).size;
    final TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    final TextStyle currentSald = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
    return Center(
      child: Stack(
        children: [
          Container(
              height: query.height * 0.25,
              width: query.width * 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image(
                  image: AssetImage('assets/tarjeta.jpg'),
                  fit: BoxFit.cover,
                ),
              )

              /* decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ), */
              ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo',
                  style: style,
                ),
                SizedBox(height: 10),
                Text(
                  '${this.amount} Bs.',
                  style: currentSald,
                ),
                SizedBox(height: 20),
                Text(
                  'Creado el ${convertDateTimeToString(this.createdAt, false)}',
                  style: style,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
