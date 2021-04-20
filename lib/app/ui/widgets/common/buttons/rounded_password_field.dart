import 'package:apnapp/app/ui/widgets/common/input/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final VoidCallback passFocus;
  final TextInputType keyboardType;

  const RoundedPasswordField({
    Key key,
    this.onChanged, @required this.controller, this.focusNode, this.textInputAction = TextInputAction.unspecified,
    this.passFocus = null, this.keyboardType,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {

  bool hideText=true;

  @override
  Widget build(BuildContext context) {

    var th = Theme.of(context);

    return TextFieldContainer(
      child: TextField(
        obscureText: hideText,
        onChanged: widget.onChanged,
        controller: widget.controller,
        focusNode: widget.focusNode,
        onEditingComplete: widget.passFocus,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        cursorColor: th.primaryColorDark,
        decoration: InputDecoration(
          hintText: "Contraseña",
          icon: Icon(
            Icons.lock,
            color: th.accentColor,
          ),
          suffixIcon: InkWell(
            onTap: () {
              hideText=!hideText;
              setState((){});
            },
            child: Icon(
              Icons.visibility,
              color: th.accentColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
