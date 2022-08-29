part of 'widgets.dart';

class NoInformation extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool showButton;
  final String? buttonTitle;
  final VoidCallback? onPressed;
  final IconData iconButton;

  NoInformation({
    required this.icon,
    required this.message,
    required this.showButton,
    this.buttonTitle,
    this.onPressed,
    required this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 110, color: Colors.white38),
            SizedBox(height: 15),
            Text(message),
            SizedBox(height: 15),
            showButton
                ? Row(
                    children: [
                      ButtonWithIcon(
                        label: buttonTitle ?? '',
                        icon: this.iconButton,
                        buttonBorderPrimary: true,
                        onPressed: onPressed!,
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
