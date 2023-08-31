import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:om_united/Components/PasswordTextField.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../Model/User.dart' as LocalUser;
import '../utilis/Utilis.dart';
import 'ImageDragged.dart';

class EditeAlertDialog extends StatefulWidget {
  final String method;

  final LocalUser.User user;

  const EditeAlertDialog({
    Key? key,
    required this.method,
    required this.user,
  }) : super(key: key);

  @override
  State<EditeAlertDialog> createState() => _EditeAlertDialogState();
}

class _EditeAlertDialogState extends State<EditeAlertDialog> {
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPss = TextEditingController();

  PlatformFile? _userPhoto;

  void setMachineImage(PlatformFile machinePhotos) {
    setState(() {
      _userPhoto = machinePhotos;
      error = "";
    });
  }

  String error = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> _chagePassword = [
      PasswordTextField(
        controller: _pass,
        text: "كلمة السر الجديدة",
      ),
      const SizedBox(height: 18),
      PasswordTextField(
        controller: _confirmPss,
        text: "تاكيد كلمة السر الجديدة",
      )
    ];
    List<Widget> _uploadPhoto = [
      ImageDragged(text: "الصورة الشخصية", url: "", photo: setMachineImage)
    ];
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: 475,
        height: widget.method == "pass" ? 310 : 350,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Column(
              children: widget.method == "pass" ? _chagePassword : _uploadPhoto,
            ),
            Text(
              error,
              style: TextStyle(
                color: Color.fromRGBO(238, 47, 47, 1),
              ),
            ),
            const SizedBox(height: 18),
            const Divider(
              height: 1,
            ),
            Container(
              decoration: const ShapeDecoration(
                color: Color.fromRGBO(6, 138, 200, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: InkWell(
                highlightColor: Colors.grey[200],
                onTap: () async {
                  if (widget.method == "pass") {
                    if (_pass.text != _confirmPss.text) {
                      setState(() {
                        error = "كلمة المرور غير متطابقة";
                      });
                    } else {
                      var request = http.MultipartRequest(
                        "POST",
                        Uri.parse("${URL_PROVIDER()}/Users.php"),
                      );
                      request.fields.addAll({
                        "id": widget.user.id.toString(),
                        "pass": _pass.text
                      });
                      var response = await request.send();
                      if (response.statusCode == 200) {
                        var res =
                            json.decode(await response.stream.bytesToString());
                        if (res["error"]) {
                          Fluttertoast.showToast(
                              msg: res["message"],
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP_RIGHT,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          FirebaseAuth.instance.currentUser
                              ?.updatePassword(_pass.text)
                              .then((e) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: res["message"],
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP_RIGHT,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          });
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "NetworkError",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    }
                  } else {
                    if (_userPhoto != null) {
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
                      request.fields.addAll({
                        "id": widget.user.id.toString(),
                      });
                      var response = await request.send();
                      if (response.statusCode == 200) {
                        var res =
                            json.decode(await response.stream.bytesToString());
                        if (res["error"]) {
                          Fluttertoast.showToast(
                              msg: res["message"],
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP_RIGHT,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          Navigator.pop(context);
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
                    } else {
                      setState(() {
                        error = "اختر صورة اولا";
                      });
                    }
                    // Navigator.pop(context);
                  }
                },
                child: Center(
                  child: Text(
                    widget.method == "pass" ? "تغير كلمة السر" : "رفع الصورة",
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
            ),
            const Divider(
              height: 1,
            ),
            SizedBox(
              height: 50,
              child: InkWell(
                highlightColor: Colors.grey[200],
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                  child: Text(
                    "إلغاء العملية",
                    style: TextStyle(
                      color: Color(0xFF068AC8),
                      fontSize: 14,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
