import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:om_united/Components/Header.dart';
import 'package:om_united/Model/User.dart';
import 'package:om_united/Pages/HomePage.dart';
import 'package:om_united/Pages/InventoryPage.dart';
import 'package:om_united/Pages/NotificationsPage.dart';
import 'package:om_united/Pages/SettingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ClientMachinesPage.dart';

class MainFragmnet extends StatefulWidget {
  final Widget subHeader;
  final Widget content;
  final bool isMainWidget;
  int? selectedIndex = 0;

  MainFragmnet(
      {Key? key,
      required this.subHeader,
      required this.content,
      required this.isMainWidget,
      this.selectedIndex})
      : super(key: key);

  @override
  State<MainFragmnet> createState() => _MainFragmnetState();
}

class _MainFragmnetState extends State<MainFragmnet> {
  String role = "";

  Future<String> getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role')!;
  }

  @override
  void initState() {
    super.initState();
    getRole().then((value) {
      setState(() {
        role = value;
      });
      NavTabs.add(GButton(
        icon: PhosphorIcons.house_line,
        text: 'الصفحة الرئيسية',
        onPressed: () => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()))
        },
      ));
      value == "admin"
          ? NavTabs.add(GButton(
              icon: PhosphorIcons.package,
              text: 'المخزون',
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => InventoryPage()));
              },
            ))
          : null;
      value == "admin"
          ? NavTabs.add(GButton(
              icon: PhosphorIcons.user_circle_bold,
              text: 'العملاء',
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClientMachinesPage()));
              },
            ))
          : null;
      NavTabs.add(GButton(
        icon: PhosphorIcons.bell_simple,
        text: 'الاشعارات',
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NotificationsPage()));
        },
      ));
      NavTabs.add(GButton(
        icon: PhosphorIcons.user,
        text: 'حسابي',
        onPressed: () async {
          User user = await FromPrefs();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SettingPage(user: user)));
        },
      ));
    });
  }

  List NavTabs = [];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext contextBottomNavigator) {
    void _onItemTapped(int index) {
      // print(index);
      setState(() async {
        User user = await FromPrefs();
        index == 0
            ? Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()))
            : index == 1
                ? Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => InventoryPage()))
                : index == 2
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientMachinesPage()))
                    : index == 3
                        ? MaterialPageRoute(
                            builder: (context) => NotificationsPage())
                        : MaterialPageRoute(
                            builder: (context) => SettingPage(user: user));
      });
    }

    return !kIsWeb
        ? Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: Container(
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
                          isMain: widget.isMainWidget,
                        )
                      : SizedBox(),
                  widget.subHeader,
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
                                hasScrollBody: false, child: widget.content)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: GNav(
                    tabBorder: Border(top: BorderSide.none),
                    rippleColor: Color.fromRGBO(29, 41, 57, 1),
                    hoverColor: Color.fromRGBO(29, 41, 57, 1),
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: Duration(milliseconds: 400),
                    tabBackgroundColor: Color.fromRGBO(29, 41, 57, 1),
                    tabs: [...NavTabs],
                    //
                    selectedIndex: widget.content.toString() ==
                            "HomePageContent"
                        ? 0
                        : widget.content.toString() == "InventoryPageContent"
                            ? NavTabs.length == 3
                                ? 1
                                : 1
                            : widget.content.toString() ==
                                    "ClientMachinesPageContent"
                                ? NavTabs.length == 3
                                    ? 1
                                    : 2
                                : widget.content.toString() == "Details"
                                    ? NavTabs.length == 3
                                        ? 2
                                        : 4
                                    : widget.content.toString() ==
                                            "NotificationsPageContent"
                                        ? NavTabs.length == 3
                                            ? 1
                                            : 3
                                        : 0,
                    onTabChange: (index) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Container(
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
                          isMain: widget.isMainWidget,
                        )
                      : SizedBox(),
                  widget.subHeader,
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(20),
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
                                hasScrollBody: false, child: widget.content)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Future<User> FromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return User(
      id: prefs.getInt("id")!,
      name: prefs.getString('name')!,
      user_name: prefs.getString('userName')!,
      email: prefs.getString('email')!,
      role: prefs.getString('role')! == "admin" ? "1" : "2",
      token: prefs.getString('token')!,
      userImage: prefs.getString('userImage')!,
    );
  }
}
