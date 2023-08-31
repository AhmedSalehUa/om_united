import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? text;

  const PasswordTextField({Key? key, required this.controller, this.text})
      : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: widget.controller,
        enableSuggestions: !_obscureText,
        autocorrect: !_obscureText,
        cursorColor: Colors.white,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? PhosphorIcons.eye_closed_light : PhosphorIcons.eye,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          labelText: widget.text!=null?widget.text!: "كلمة المرور",
          labelStyle: const TextStyle(
              color: Color.fromRGBO(152, 162, 179, 1),
              fontWeight: FontWeight.w400,
              fontFamily: "santo",
              fontSize: 16),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: const Color.fromRGBO(249, 250, 251, 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: Color.fromRGBO(208, 213, 221, 1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: Color.fromRGBO(208, 213, 221, 1),
            ),
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureText,
      ),
    );
  }
}
