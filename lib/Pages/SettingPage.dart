import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:om_united/Components/EditeAlertDialog.dart';
import 'package:om_united/ListItems/UserItem.dart';
import 'package:om_united/utilis/Utilis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentications/Login.dart';
import '../Components/CustomAlertDialog.dart';
import '../Components/Header.dart';
import '../Components/Widgets.dart';
import 'package:http/http.dart' as http;
import '../ListItems/UserForm.dart';
import '../Model/User.dart' as LocalUser;
import 'HomePage.dart';
import 'MainFragmnet.dart';
import 'MiniFragmnet.dart';

class SettingPage extends StatefulWidget {
  LocalUser.User? user;

  SettingPage({Key? key, this.user}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  LocalUser.User? user;

  Future<LocalUser.User> getCurrentUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    LocalUser.User user = LocalUser.User(
      id: prefs.getInt("id")!,
      name: prefs.getString('name')!,
      user_name: prefs.getString('userName')!,
      email: prefs.getString('email')!,
      role: prefs.getString('role')! == "admin" ? "1" : "2",
      token: prefs.getString('token')!,
      userImage: prefs.getString('userImage')!,
    );
    return user;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.user != null) {
      user = widget.user!;
    } else {
      getCurrentUsers().then((value) {
        setState(() {
          user = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? SizedBox()
        : kIsWeb
        ? MiniFragmnet(
      content: Details(
        user: user!,
      ),
    )
        : Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(26, 26, 36, 1),
        image: DecorationImage(
          image: AssetImage("assets/images/ContainerBackground.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          kIsWeb
              ? Header(
            isMain: false,
          )
              : SizedBox(),
          SubHeader(
            user: user!,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.only(bottom: 5),
              decoration: const ShapeDecoration(
                color: Color.fromRGBO(249, 250, 251, 1),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 0.50,
                      color: Color.fromRGBO(52, 64, 84, 1)),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
              ),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                        hasScrollBody: false,
                        child: Details(
                          user: user!,
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Details extends StatefulWidget {
  final LocalUser.User user;

  const Details({Key? key, required this.user}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  List<LocalUser.User> _userList = [];

  void fetchData() async {
    try {
      final response =
      await http.get(Uri.parse("${URL_PROVIDER()}/Users.php"), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      final jsonData = jsonDecode(response.body)["data"];
      final List<LocalUser.User> items = [];
      for (var itemJson in jsonData) {
        final item = LocalUser.User.fromJson(itemJson);
        items.add(item);
      }

      setState(() {
        _userList = items;
      });
    } catch (e) {
      print("excep ${e}");
      throw Exception('Failed to fetch data: $e');
    }
  }

  String role = "";

  Future<String> getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role')!;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _userNameTextController.value =
        TextEditingValue(text: widget.user.user_name);
    _emailTextController.value = TextEditingValue(text: widget.user.email);
    getRole().then((value) =>
        setState(() {
          role = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0x14344054)),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !kIsWeb
                      ? subHeaderButton('تسجيل خروج', PhosphorIcons.door, () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()));
                  },
                      color: const Color.fromRGBO(249, 213, 218, 1),
                      shadow: const Color.fromRGBO(249, 213, 218, 1))
                      : SizedBox(),
                  SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "بياناتك الشخصية",
                    style: TextStyle(
                      color: Color(0xFF1A1A24),
                      fontSize: 24,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        onPressed: () =>
                        {
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: "هل انت متأكد من حذف الصورة الشخصية",
                                description: "لن تستطيع اعادته مرة أخرى",
                                onConfirm: () async {
                                  var request = http.MultipartRequest(
                                    "POST",
                                    Uri.parse("${URL_PROVIDER()}/Users.php"),
                                  );
                                  // print(widget.user.id);

                                  request.fields.addAll({
                                    "id": widget.user.id.toString(),
                                    "img":
                                    "https://static.vecteezy.com/system/resources/thumbnails/004/607/806/small/man-face-emotive-icon-smiling-bearded-male-character-in-yellow-flat-illustration-isolated-on-white-happy-human-psychological-portrait-positive-emotions-user-avatar-for-app-web-design-vector.jpg",
                                  });
                                  var response = await request.send();
                                  if (response.statusCode == 200) {
                                    var res = json.decode(
                                        await response.stream.bytesToString());
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
                                              builder: (context) =>
                                              const HomePage()));
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
                          "حذف الصورة",
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
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        onPressed: () =>
                        {
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (context) {
                              return EditeAlertDialog(
                                user: widget.user,
                                method: "upload",
                              );
                            },
                          )
                        },
                        icon: const Icon(
                          PhosphorIcons.upload_simple,
                          size: 18,
                          color: Color(0xFF1A1A24),
                        ),
                        label: const Text(
                          "رفع صورة شخصية",
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
                    widget.user.userImage != ""
                        ? CircleAvatar(
                      child: Image.network(widget.user.userImage),
                    )
                        : RawMaterialButton(
                      elevation: 2.0,
                      fillColor: const Color.fromRGBO(205, 230, 244, 1),
                      padding: const EdgeInsets.all(26),
                      shape: const CircleBorder(),
                      onPressed: () {},
                      child: const Icon(
                        PhosphorIcons.user,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 420,
                child:
                noIconedTextField('اسم المستخدم', _userNameTextController,
                    onTextChange: (value) async {
                      final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      await prefs.setString("NewUserName", value);
                      await prefs.setString("NewName", value);
                    }, height: 60),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0x14344054)),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "بيانات الحساب",
                style: TextStyle(
                  color: Color(0xFF1A1A24),
                  fontSize: 24,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 420,
                child: noIconedTextField("الايميل", _emailTextController,
                    onTextChange: (value) async {
                      final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      await prefs.setString("NewEmail", value);
                    }, height: 60),
              ),
              const SizedBox(
                height: 20,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: () =>
                  {
                    showDialog(
                      barrierColor: Colors.black26,
                      context: context,
                      builder: (context) {
                        return EditeAlertDialog(
                          user: widget.user,
                          method: "pass",
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
                    "تغير كلمة المرور",
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
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        role == "admin"
            ? Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side:
              const BorderSide(width: 0.50, color: Color(0x14344054)),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      onPressed: () =>
                      {
                        showModalBottomSheet<void>(
                          context: context,
                          elevation: 2,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                                width: 0.50, color: Color(0x14344054)),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(21),
                                topLeft: Radius.circular(21)),
                          ),
                          builder: (BuildContext context) {
                            final screenHeight =
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height;
                            final desiredHeight = screenHeight *
                                0.9; // set the height to 90% of the screen height
                            return Container(
                              height: desiredHeight,
                              child: UserForm(),
                            );
                          },
                        )
                      },
                      icon: const Icon(
                        PhosphorIcons.plus_light,
                        size: 18,
                        color: Color(0xFF1A1A24),
                      ),
                      label: const Text(
                        "إضافة مستخدم جديد",
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
                  const Text(
                    "المستخدمين",
                    style: TextStyle(
                      color: Color(0xFF1A1A24),
                      fontSize: 18,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: (_userList.length * 80),
                child: ListView.builder(
                  itemCount: _userList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {},
                      child: ListTile(
                          title: UserItem(
                            user: _userList[index],
                          )),
                    );
                  },
                ),
              ),
            ],
          ),
        )
            : SizedBox()
      ],
    );
    return kIsWeb
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Header(
          isMain: false,
        ),
        SubHeader(user: widget.user),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(20),
            decoration: const ShapeDecoration(
              color: Color.fromRGBO(249, 250, 251, 1),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 0.50, color: Color.fromRGBO(52, 64, 84, 1)),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: content,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    )
        : Column(
      children: [content],
    );
  }
}

class SubHeader extends StatefulWidget {
  final LocalUser.User user;

  const SubHeader({Key? key, required this.user}) : super(key: key);

  @override
  State<SubHeader> createState() => _SubHeaderState();
}

class _SubHeaderState extends State<SubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kIsWeb
          ? const EdgeInsets.all(15)
          : const EdgeInsets.fromLTRB(15, 60, 15, 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'الاعدادات',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: kIsWeb ? 32 : 16,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              kIsWeb
                  ? IconButton(
                icon: const Icon(
                  PhosphorIcons.arrow_right,
                  color: Colors.white,
                  size: 24,
                ),
                tooltip: 'عودة',
                onPressed: () {
                  Navigator.pop(context);
                },
              )
                  : const SizedBox(),
            ],
          ),
          Positioned(
            bottom: kIsWeb ? 0 : null,
            left: kIsWeb ? 0 : null,
            child: Row(
              children: [
                subHeaderNoIconButton(
                  'حفظ التغيرات',
                  onSaveTap,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSaveTap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getString("NewUserName") == "") &&
        (prefs.getString("NewEmail") == "")) {} else {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${URL_PROVIDER()}/Users.php"),
      );
      request.fields.addAll({
        "id": widget.user.id.toString(),
      });
      if (prefs.getString("NewUserName") != "") {
        request.fields.addAll({
          "name": prefs.getString("NewUserName")!,
          "user_name": prefs.getString("NewUserName")!
        });
      }

      if (prefs.getString("NewEmail") != "") {
        request.fields.addAll({
          "email": prefs.getString("NewEmail")!,
        });
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        var res = json.decode(await response.stream.bytesToString());
        if (res["error"]) {
          Fluttertoast.showToast(
              msg: res["message"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP_RIGHT,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          if (prefs.getString("NewEmail") != "") {
            FirebaseAuth.instance.currentUser
                ?.updateEmail(prefs.getString("NewEmail")!)
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
}
