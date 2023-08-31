
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'LoginForm.dart';
import 'LoginWeb.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: <Widget>[
              if (kIsWeb) LoginWeb(),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
