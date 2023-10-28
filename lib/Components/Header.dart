import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/Model/User.dart';
import 'package:om_united/Pages/ClientMachinesPage.dart';
import 'package:om_united/Pages/HomePage.dart';
import 'package:om_united/Pages/InventoryPage.dart';
import 'package:om_united/Pages/SearchResult.dart';
import 'package:om_united/Pages/SettingPage.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentications/Login.dart';
import '../Pages/NotificationsPage.dart';

class Header extends StatefulWidget {
  final bool isMain;

  const Header({Key? key, required this.isMain}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String role = "";

  Future<String> getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role')!;
  }

  @override
  void initState() {
    super.initState();
    getRole().then((value) => setState(() {
          role = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              RawMaterialButton(
                onPressed: () {
                  showPopover(
                    context: context,
                    bodyBuilder: (context) => const ListItems(),
                    direction: PopoverDirection.bottom,
                    width: 200,
                    height: 100,
                    arrowHeight: 15,
                    arrowWidth: 30,
                  );
                },
                elevation: 2.0,
                fillColor: const Color.fromRGBO(205, 230, 244, 1),
                padding: const EdgeInsets.all(10),
                shape: const CircleBorder(),
                child: const Icon(
                  PhosphorIcons.user,
                  size: 18,
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  showPopover(
                    context: context,
                    bodyBuilder: (context) => SingleChildScrollView(
                        child: const NotificationsPageContent()),
                    direction: PopoverDirection.bottom,
                    width: 385,
                    height: 492,
                    arrowHeight: 15,
                    arrowWidth: 30,
                  );
                },
                elevation: 2.0,
                padding: const EdgeInsets.all(10),
                shape: const CircleBorder(),
                child: const Icon(
                  PhosphorIcons.bell_simple,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 254,
                height: 36,
                decoration: ShapeDecoration(
                  color: const Color(0xFF344054),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        width: 0.50, color: Color.fromRGBO(52, 64, 84, 1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onSubmitted: (a) async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      User user = User(
                        id: prefs.getInt("id")!,
                        name: prefs.getString('name')!,
                        user_name: prefs.getString('userName')!,
                        email: prefs.getString('email')!,
                        role: prefs.getString('role')! == "admin" ? "1" : "2",
                        token: prefs.getString('token')!,
                        userImage: prefs.getString('userImage')!,
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                          SearchResult(SearchKey: a,user:user)
                       ));
                    },
                    cursorColor: Colors.white,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: const Icon(
                          PhosphorIcons.magnifying_glass,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {},
                      ),
                      labelText: 'ابحث عن منتجات',
                      labelStyle: const TextStyle(
                        color: Color(0xFFE4E7EC),
                        fontSize: 12,
                        fontFamily: 'santo',
                        fontWeight: FontWeight.w400,
                        height: 16,
                        letterSpacing: 0.40,
                      ),
                      fillColor: const Color.fromRGBO(52, 64, 84, 1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          width: 0.50,
                          color: Color.fromRGBO(52, 64, 84, 1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          width: 0.50,
                          color: Color.fromRGBO(52, 64, 84, 1),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              role == "admin"
                  ? Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Scaffold(body: ClientMachinesPage())));
                        },
                        icon: Icon(
                          PhosphorIcons.user_circle_bold,
                          size: 24.0,
                          color: Color(0xFF98A1B2),
                        ),
                        label: Text(
                          'العملاء',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF98A1B2),
                            fontSize: 14,
                            fontFamily: 'santo',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(73),
                              side: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 10,
                    ),
              const SizedBox(
                width: 10,
              ),
              role == "admin"
                  ? Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Scaffold(body: InventoryPage())));
                        },
                        icon: Icon(
                          PhosphorIcons.package,
                          size: 24.0,
                          color:
                              widget.isMain ? Color(0xFF98A1B2) : Colors.white,
                        ),
                        label: Text(
                          'المخزون',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: widget.isMain
                                ? Color(0xFF98A1B2)
                                : Colors.white,
                            fontSize: 14,
                            fontFamily: 'santo',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(73),
                              side: BorderSide(
                                  color: widget.isMain
                                      ? Colors.transparent
                                      : const Color.fromRGBO(
                                          255, 255, 255, .2)),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 10,
                    ),
              const SizedBox(
                width: 10,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(body: HomePage())));
                  },
                  icon: Icon(
                    PhosphorIcons.house_line,
                    size: 24.0,
                    color:
                        widget.isMain ? Colors.white : const Color(0xFF98A1B2),
                  ),
                  label: Text(
                    'الصفحة الرئيسية',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: widget.isMain
                          ? Colors.white
                          : const Color(0xFF98A1B2),
                      fontSize: 14,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.10,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(73),
                        side: BorderSide(
                          color: widget.isMain
                              ? const Color.fromRGBO(255, 255, 255, .2)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          subHeaderButton(
            'اعدادات',
            PhosphorIcons.wrench,
            () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              User user = User(
                id: prefs.getInt("id")!,
                name: prefs.getString('name')!,
                user_name: prefs.getString('userName')!,
                email: prefs.getString('email')!,
                role: prefs.getString('role')! == "admin" ? "1" : "2",
                token: prefs.getString('token')!,
                userImage: prefs.getString('userImage')!,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingPage(
                    user: user,
                  ),
                ),
              );
            },
          ),
          //
          const Divider(),
          subHeaderButton('تسجيل خروج', PhosphorIcons.door, () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString('email', "");
            await prefs.setString('pass', "");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
              color: const Color.fromRGBO(249, 213, 218, 1),
              shadow: const Color.fromRGBO(249, 213, 218, 1)),
        ],
      ),
    );
  }
}
