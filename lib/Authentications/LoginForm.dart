import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:om_united/Components/PasswordTextField.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/Pages/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:om_united/Model/User.dart' as Local;
import '../Fragments/MobileFragment.dart';
import '../Fragments/WebFragment.dart';
import '../utilis/Utilis.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();

  String error = "";

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        margin: kIsWeb ? EdgeInsets.all(20) : EdgeInsets.all(10),
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment:
              kIsWeb ? Alignment.bottomRight : Alignment.bottomCenter,
              child: SvgPicture.asset("assets/images/logoSvg.svg",
                  semanticsLabel: 'My Image',
                  width: kIsWeb ? 100 : 150,
                  height: kIsWeb ? 100 : 150),
              // child: ImageWidget("assets/images/logo.jpg", kIsWeb ?100:150,kIsWeb ?100:150),
            ),
            Container(
              margin: kIsWeb ? EdgeInsets.all(100) : EdgeInsets.all(30),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "santo",
                        fontWeight: FontWeight.w600,
                        color: hexStringToColor("1A1A24"),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  noIconedTextField(
                      "البريد الإلكتروني", _usernameTextController,
                      onTextChange: (value) {}),
                  const SizedBox(
                    height: 30,
                  ),
                  PasswordTextField(controller: _passwordTextController),
                  const SizedBox(
                    height: 30,
                  ), Text(
                    error,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color.fromRGBO(238, 47, 47, 1),
                    ),
                  ), const SizedBox(
                    height: 30,
                  ),
                  signInUpButton(context, true, () async {
                    final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    final String? action = _usernameTextController.text;

                    final String url = '${URL_PROVIDER()}/Auth.php';

                    Map<String, String> data;
                    if (!kIsWeb) {
                      data = {
                        'email': action!, 'pass': _passwordTextController.text,
                        'token': prefs.getString("token")!
                      };
                    } else {
                      data =
                      {'email': action!, 'pass': _passwordTextController.text,};
                    }
                    final response = await http.post(
                      Uri.parse(url),
                      body: data,
                    );
                    if (response.statusCode == 200) {
                      if (json.decode(response.body)["data"].length == 0) {
                        setState(() {
                          error = "خطا فى اسم المستخدم او كلمة المرور";
                        });
                      } else {
                        Local.User user = Local.User.fromJson(
                            json.decode(response.body)["data"][0]);
                        await prefs.setInt('id', user.id);
                        await prefs.setString('email', user.email);
                        await prefs.setString('pass',  _passwordTextController.text);
                        await prefs.setString('name', user.name);
                        await prefs.setString('userName', user.user_name);
                        await prefs.setString('userImage', user.userImage);
                        await prefs.setString('token', user.token);
                        await prefs.setString("NewUserName", "");
                        await prefs.setString("NewName", "");
                        await prefs.setString("NewEmail", "");
                        await prefs.setString(
                            'role', user.role == "1" ? "admin" : "maintaince");
                        try {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                              email: _usernameTextController.text,
                              password: _passwordTextController.text)
                          ;
                        } catch (rx) {}
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => kIsWeb ? WebFragment(): MobileFragment() )
                        );
                      }
                    } else {
                      setState(() {
                        error = "غير قادر على الوصول للسيرفر";
                      });
                    }
                  })
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: const Text(" ©جميع الحقوق محفوظة ٢٠٢٣ "),
            ),
          ],
        ),
      ),
    );
  }
}
// FirebaseAuth.instance
//                        .signInWithEmailAndPassword(
//                            email: _usernameTextController.text,
//                            password: _passwordTextController.text)
//                        .then((value) async {
//
//                      final SharedPreferences prefs =
//                          await SharedPreferences.getInstance();
//
//                        final String? action = _usernameTextController.text;
//
//                        final String url = '${URL_PROVIDER()}/Auth.php';
//
//                        Map<String, String> data;
//                        if (!kIsWeb) {
//                          data = {'email': action!, 'token': prefs.getString("token")!};
//                        } else {
//                          data = {'email': action!};
//                        }
//                        final response = await http.post(
//                          Uri.parse(url),
//                          body: data,
//                        );
//                        if (response.statusCode == 200) {
//                          Local.User user = Local.User.fromJson(json.decode(response.body)["data"][0]);
//                          await prefs.setInt('id', user.id);
//                          await prefs.setString('name', user.name);
//                          await prefs.setString('userName', user.user_name);
//                          await prefs.setString('userImage', user.userImage);
//                          await prefs.setString('token', user.token);
//                          await prefs.setString('role', user.role == "1"? "admin" : "maintaince");
//                          Navigator.pushReplacement(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (context) => HomePage()));
//                        } else {
//                          print('Error loggin user');
//                        }
//                    });
//                  }
