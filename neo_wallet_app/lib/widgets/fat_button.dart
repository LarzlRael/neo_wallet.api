part of 'widgets.dart';

class FatButton extends StatelessWidget {
  final Widget title;
  final VoidCallback? onPressed;

  @override
  const FatButton({
    required this.title,
    required this.onPressed,
    /* required this.onPressed, */
  });
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        primary: Colors.blue,
        shape: StadiumBorder(),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        child: Center(
          child: this.title,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
