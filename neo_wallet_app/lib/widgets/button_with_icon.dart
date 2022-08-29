part of 'widgets.dart';

class ButtonWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool buttonBorderPrimary;
  final styleLabelButton = TextStyle(color: Colors.white, fontSize: 16);
  final VoidCallback onPressed;

  ButtonWithIcon(
      {required this.icon,
      required this.label,
      required this.buttonBorderPrimary,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      /* padding: EdgeInsets.symmetric(horizontal: 5),
      color: Colors.amber, */
      /* width: double.infinity, */
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: TextButton.icon(
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: styleLabelButton),
          onPressed: this.onPressed,
          style: buttonsStyles(context),
        ),
      ),
    );
  }

  buttonsStyles(BuildContext context) {
    return ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      primary: Colors.transparent,
      side: BorderSide(
        width: .8,
        color:
            buttonBorderPrimary ? Theme.of(context).accentColor : Colors.white,
      ),
    );
  }
}
