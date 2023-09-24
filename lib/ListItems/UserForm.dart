import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:om_united/Pages/HomePage.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/ImageDragged.dart';
import '../Components/PasswordTextField.dart';
import '../Components/Widgets.dart';
import '../Model/User.dart' as local;
import 'package:http/http.dart' as http;

import '../utilis/Utilis.dart';

class UserForm extends StatefulWidget {
  final local.User? user;

  const UserForm({Key? key, this.user}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  PlatformFile? _userPhoto;

  TextEditingController _name = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _role = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _passConfirm = TextEditingController();
  String role = "1";

  void setContractImage(PlatformFile contractPhotos) {
    setState(() {
      _userPhoto = contractPhotos;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _name.value = TextEditingValue(text: widget.user!.user_name);
      _email.value = TextEditingValue(text: widget.user!.email);

      setState(() {
        role = widget.user!.role;
      });
    }
  }

  String error = "";

  @override
  Widget build(BuildContext context) {
    Future<void> Submit() async {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${URL_PROVIDER()}/Users.php"),
      );
      if (kIsWeb) {
        if (_userPhoto != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              "file",
              _userPhoto!.bytes!,
              filename: _userPhoto!.name,
            ),
          );
        }
      } else {
        if (_userPhoto != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "file",
              _userPhoto!.path!,
              filename: basename(_userPhoto!.path!),
            ),
          );
        }
      }
      if (widget.user != null) {
        if (_email.text != "") {
          request.fields.addAll({
            "email": _email.text,
          });
        }
        if (_name.text != "") {
          request.fields.addAll({
            "name": _name.text,
            "user_name": _name.text,
          });
        }
        if (_pass.text != "") {
          request.fields.addAll({
            "pass": _pass.text,
          });
        }
        request.fields.addAll({
          "id": widget.user!.id.toString(),
          "role": role,
        });
      } else {
        if (_email.text != "") {
          setState(() {
            error = "";
          });
          if (_pass.text == _passConfirm.text) {
            setState(() {
              error = "";
            });
            request.fields.addAll({
              "name": _name.text,
              "user_name": _name.text,
              "email": _email.text,
              "pass": _pass.text,
              "role": role,
            });
          } else {
            setState(() {
              error = "الياسورد غير متطابق";
            });
          }
        } else {
          setState(() {
            error = "ادخل الايميل";
          });
        }
      }
      if (error == "") {
        var response = await request.send();

        if (response.statusCode == 200) {
          var res = json.decode(await response.stream.bytesToString());
          // print(res);
          if (res["error"]) {
            setState(() {
              error = res["message"];
            });
          } else {
            if (widget.user == null)   {

              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _email.text, password: _pass.text)
                  .then((value) => {/*print(value)*/});
            }
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
            Fluttertoast.showToast(
                msg: res["message"],
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP_RIGHT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
            msg: "NetworkError",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    }

    return Padding(
            padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom),

      child: SingleChildScrollView(
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0x14344054)),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
          padding: kIsWeb ? const EdgeInsets.all(15) : const EdgeInsets.all(0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0x14344054)),
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Container(
                width: kIsWeb
                    ? MediaQuery.of(context).size.width * .4
                    : MediaQuery.of(context).size.width,
                child: Column(children: [
                  Align(
                      alignment: AlignmentDirectional.center,
                      child: ImageDragged(
                          text: "صورة المستخدم",
                          url: widget.user != null ? widget.user!.userImage : "",
                          photo: setContractImage)),
                  const SizedBox(
                    height: 10,
                  ),
                  noIconedTextField(
                    'الاسم بالكامل',
                    _name,
                    onTextChange: (value) {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Text(
                        'الصلاحية / الدور',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF1A1A24),
                          fontSize: 16,
                          fontFamily: 'santo',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            role = "1";
                          });
                        },
                        child: Container(
                          width: 82,
                          height: 34,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: ShapeDecoration(
                            color: role == "1" ? Color(0xFFCDE6F4) : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.50,
                                  color: role == "1"
                                      ? Color.fromRGBO(6, 138, 200, 1)
                                      : Color(0xFFD0D5DD)),
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'مدير',
                              style: TextStyle(
                                color: Color(0xFF1A1A24),
                                fontSize: 14,
                                fontFamily: 'santo',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            role = "2";
                          });
                        },
                        child: Container(
                          width: 82,
                          height: 34,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: ShapeDecoration(
                            color: role == "2" ? Color(0xFFCDE6F4) : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.50,
                                  color: role == "2"
                                      ? Color.fromRGBO(6, 138, 200, 1)
                                      : Color(0xFFD0D5DD)),
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'فني',
                              style: TextStyle(
                                color: Color(0xFF1A1A24),
                                fontSize: 14,
                                fontFamily: 'santo',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
              ),
            ),
            Divider(
              height: 3,
            ),
            Container(
              width: kIsWeb
                  ? MediaQuery.of(context).size.width * .4
                  : MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.50, color: Color(0x14344054)),
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: widget.user != null
                        ? Container(
                            decoration: const ShapeDecoration(
                              color: Color.fromRGBO(6, 138, 200, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: InkWell(
                              highlightColor: Colors.grey[200],
                              onTap: () {
                                Submit();
                              },
                              child: Center(
                                child: Text(
                                  widget.user != null
                                      ? "تعديل"
                                      : "اضافة المستخدم",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'santo',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Column(children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Text(
                                  'بيانات الحساب',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xFF1A1A24),
                                    fontSize: 16,
                                    fontFamily: 'santo',
                                    fontWeight: FontWeight.w600,
                                    height: 1.50,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ),
                            ),
                            noIconedTextField("البريد الالكتروني", _email,
                                onTextChange: (value) {}, height: 40),
                            const SizedBox(
                              height: 10,
                            ),
                            PasswordTextField(
                              controller: _pass,
                              text: "كلمة السر",
                            ),
                            const SizedBox(height: 18),
                            PasswordTextField(
                              controller: _passConfirm,
                              text: "تاكيد كلمة السر",
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              error,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color.fromRGBO(238, 47, 47, 1),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(6, 138, 200, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: InkWell(
                                highlightColor: Colors.grey[200],
                                onTap: () {
                                  Submit();
                                },
                                child: Center(
                                  child: Text(
                                    widget.user != null
                                        ? "تعديل"
                                        : "اضافة المستخدم",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'santo',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
