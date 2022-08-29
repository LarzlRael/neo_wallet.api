part of 'widgets.dart';

class CustomInput extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput({
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    //

    return Container(
      padding: EdgeInsets.only(top: 0, left: 5, bottom: 0, right: 20),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white),
      ),
      child: TextField(
        controller: this.widget.textController,
        obscureText: this.widget.isPassword ? showPassword : false,
        keyboardType: this.widget.keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            this.widget.icon,
            color: Colors.blue,
          ),
          suffixIcon: this.widget.isPassword
              ? IconButton(
                  icon: showPassword
                      ? Icon(Icons.password)
                      : Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                )
              : null,
          hintText: this.widget.placeholder,
        ),
      ),
    );
  }
}
