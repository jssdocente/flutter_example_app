import 'package:apnapp/app/ui/widgets/common/input/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final VoidCallback passFocus;
  final TextInputAction textInputAction;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged, @required this.controller, this.focusNode, this.keyboardType = TextInputType.text,
    this.passFocus, this.textInputAction = TextInputAction.unspecified,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);

    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        controller: controller ,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onEditingComplete: passFocus,
        cursorColor: th.primaryColorDark,
        decoration: InputDecoration(
          fillColor: th.primaryColorLight,
          icon: Icon(
            icon,
            color: th.accentColor,
          ),
          hintText: hintText,
          hintStyle: th.textTheme.bodyText2.copyWith(color: th.dividerColor.withOpacity(0.2) ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}