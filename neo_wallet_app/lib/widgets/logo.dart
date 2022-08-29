part of 'widgets.dart';

class Logo extends StatelessWidget {
  final String title;

  const Logo({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      width: 160,
      child: Column(
        children: [
          FadeIn(
            duration: Duration(milliseconds: 2000),
            child: Image(
              image: AssetImage('assets/logo_blanco.png'),
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
