import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:popover/popover.dart';
import '../Authentications/Login.dart';
import '../Components/MiniHeader.dart';
import '../Components/Widgets.dart';
import '../FormPages/AddMachine.dart';
import '../Pages/AssetsManagment.dart';
import '../Pages/ClientMachines.dart';
import '../Pages/Home.dart';
import '../Pages/Inventory.dart';
import '../Pages/Notifications.dart';
import '../Pages/SearchResult.dart';
import '../Pages/Setting.dart';
import '../Model/User.dart' as LocalUser;

class WebFragment extends StatefulWidget {
  int? selectedIndex = 0;

  WebFragment({super.key, this.selectedIndex});

  @override
  State<WebFragment> createState() => _WebFragmentState();
}

class _WebFragmentState extends State<WebFragment> {
  String role = "";
  int _selectedIndex = 0;

  LocalUser.User? user;

  Future<String> getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role')!;
  }

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
    super.initState();
    setState(() {
      _selectedIndex =
          widget!.selectedIndex != null ? widget.selectedIndex! : 0;
    });
    getCurrentUsers().then((value) {
      setState(() {
        user = value;
      });
    });
    getRole().then((value) => setState(() {
          role = value;
        }));

  }

  @override
  Widget build(BuildContext context) {
    List content = [Home(), Inventory(), AssetsManagment(), ClientMachines()];
    // return AddMachine() ;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(26, 26, 36, 1),
          image: DecorationImage(
            image: AssetImage("assets/images/ContainerBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      MiniHeader(),
                      Container(
                        width: 254,
                        height: 36,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF344054),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(52, 64, 84, 1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            onSubmitted: (a) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchResult(
                                          SearchKey: a, user: user)));
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
                          ? MenuItem(
                              name: "العملاء",
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 3;
                                });
                              },
                              icon: PhosphorIcons.user_circle_bold,
                              selectedIndex: _selectedIndex,
                              index: 3)
                          : const SizedBox(
                              width: 10,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      role == "admin"
                          ? MenuItem(
                              name: "الاصول",
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                              icon: PhosphorIcons.package,
                              selectedIndex: _selectedIndex,
                              index: 2)
                          : const SizedBox(
                              width: 10,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      role == "admin"
                          ? MenuItem(
                              name: "المخزون",
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              icon: PhosphorIcons.package,
                              selectedIndex: _selectedIndex,
                              index: 1)
                          : const SizedBox(
                              width: 10,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      MenuItem(
                          name: "الصفحة الرئيسية",
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          icon: PhosphorIcons.house_line,
                          selectedIndex: _selectedIndex,
                          index: 0)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(flex: 1,
                child: Container(
              child: content.elementAt(_selectedIndex),
            ))
            // content.elementAt(_selectedIndex),
          ],
        ),
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  LocalUser.User? user;

  ListItems({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("object");
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            subHeaderButton(
              'اعدادات',
              PhosphorIcons.wrench,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Setting(
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
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  final String name;

  final Function onTap;

  final int selectedIndex;

  final int index;

  final IconData icon;

  const MenuItem(
      {super.key,
      required this.name,
      required this.icon,
      required this.onTap,
      required this.selectedIndex,
      required this.index});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () => widget.onTap(),
        icon: Icon(
          widget.icon,
          size: 24.0,
          color: widget.selectedIndex == widget.index
              ? Colors.white
              : const Color(0xFF98A1B2),
        ),
        label: Text(
          widget.name,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: widget.selectedIndex == widget.index
                ? Colors.white
                : const Color(0xFF98A1B2),
            fontSize: 14,
            fontFamily: 'santo',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.10,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(73),
              side: BorderSide(
                color: widget.selectedIndex == widget.index
                    ? const Color.fromRGBO(255, 255, 255, .2)
                    : Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
