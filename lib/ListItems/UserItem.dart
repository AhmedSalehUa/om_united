import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:om_united/ListItems/UserForm.dart';
import 'package:om_united/Pages/HomePage.dart';
import 'package:popover/popover.dart';

import '../Components/CustomAlertDialog.dart';
import '../Model/User.dart';
import 'package:http/http.dart' as http;

import '../utilis/Utilis.dart';

class UserItem extends StatefulWidget {
  final User user;

  const UserItem({super.key, required this.user});

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    List<Widget> operattions = [
      Directionality(
        textDirection: TextDirection.rtl,
        child: TextButton.icon(
          onPressed: () => {
            showModalBottomSheet<void>(
              context: context,
              elevation: 2,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                side: BorderSide(width: 0.50, color: Color(0x14344054)),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(21),
                    topLeft: Radius.circular(21)),
              ),
              builder: (BuildContext context) {
                final screenHeight = MediaQuery.of(context).size.height;
                final desiredHeight = screenHeight *
                    0.9; // set the height to 90% of the screen height
                return Container(
                  height: desiredHeight,
                  child: UserForm(
                    user: widget.user,
                  ),
                );
              },
            )
          },
          icon: const Icon(
            PhosphorIcons.pencil_simple,
            size: 18,
            color: Color(0xFF1A1A24),
          ),
          label: const Text(
            "تعديل البيانات",
            style: TextStyle(
              color: Color(0xFF1A1A24),
              fontSize: 14,
              fontFamily: 'santo',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.10,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.white,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
      Directionality(
        textDirection: TextDirection.rtl,
        child: TextButton.icon(
          onPressed: () => {
            showDialog(
              barrierColor: Colors.black26,
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  title: "هل انت متأكد من رغبتك في حذف المستخدم",
                  description: "لن تستطيع اعادته مرة أخرى",
                  onConfirm: () async {
                    var request = http.MultipartRequest(
                      "POST",
                      Uri.parse("${URL_PROVIDER()}/Users.php"),
                    );
                    request.fields.addAll({
                      "id": widget.user.id.toString(),
                      "delete": "true",
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
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
                  },
                );
              },
            )
          },
          icon: const Icon(
            PhosphorIcons.trash_simple,
            size: 18,
            color: Color.fromRGBO(238, 47, 47, 1),
          ),
          label: const Text(
            "حذف المستخدم",
            style: TextStyle(
              color: Color.fromRGBO(238, 47, 47, 1),
              fontSize: 14,
              fontFamily: 'santo',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.10,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.white,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        kIsWeb
            ? Row(
                children: operattions,
              )
            : IconButton(
                onPressed: () {
                  showPopover(
                    context: context,
                    bodyBuilder: (context) => Column(
                      children: operattions,
                    ),
                    direction: PopoverDirection.bottom,
                    width: 200,
                    height: 100,
                    arrowHeight: 0,
                    arrowWidth: 0,
                  );
                },
                icon: Icon(PhosphorIcons.circles_three_thin)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: ShapeDecoration(
                          color: widget.user.role == "1"
                              ? Color.fromRGBO(213, 225, 252, 1)
                              : Color.fromRGBO(209, 245, 231, 1),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 0.50, color: Color(0x14344054)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.user.role == "1" ? "مدير" : "فني",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: widget.user.role == "1"
                                  ? Color.fromRGBO(47, 105, 238, 1)
                                  : Color.fromRGBO(18, 166, 107, 1),
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.user.user_name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "santo",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "santo",
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: CircleAvatar(backgroundColor: Colors.white,
                child: Image.network(widget.user.userImage),
              ),
            ),
          ],
        )
      ],
    );
  }
}
