import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:om_united/Model/User.dart';
import 'package:om_united/Pages/AssetsManagment.dart';
import 'package:om_united/Pages/Home.dart';
import 'package:om_united/Pages/Inventory.dart';
import 'package:om_united/Pages/Notifications.dart';
import 'package:om_united/Pages/Setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/User.dart' as LocalUser;
import '../Pages/ClientMachines.dart';

class MobileFragment extends StatefulWidget {
  int? selectedIndex = 0;
  LocalUser.User? user;

  MobileFragment({Key? key, this.user, this.selectedIndex}) : super(key: key);

  @override
  State<MobileFragment> createState() => _MobileFragmentState();
}

class _MobileFragmentState extends State<MobileFragment> {
  String role = "";

  List NavTabs = [];
  List Headers = [];
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

    if (widget.user != null) {
      user = widget.user!;
    } else {
      setState(() {
        getCurrentUsers().then((value) => user = value);
      });
    }
    setState(() {
      _selectedIndex =
          widget!.selectedIndex != null ? widget.selectedIndex! : 0;
    });
    getRole().then((value) {
      setState(() {
        role = value;
      });
      NavTabs.add(GButton(
        icon: PhosphorIcons.house_line,
        text: 'الصفحة الرئيسية',
      ));
      value == "admin"
          ? NavTabs.add(GButton(
              icon: PhosphorIcons.package,
              text: 'المخزون',
            ))
          : null;
      value == "admin"
          ? NavTabs.add(GButton(
        icon: PhosphorIcons.package,
        text: 'الاصول',
      ))
          : null;
      value == "admin"
          ? NavTabs.add(GButton(
              icon: PhosphorIcons.user_circle_bold,
              text: 'العملاء',
            ))
          : null;
      NavTabs.add(GButton(
        icon: PhosphorIcons.bell_simple,
        text: 'الاشعارات',
      ));
      NavTabs.add(GButton(
        icon: PhosphorIcons.user,
        text: 'حسابي',
      ));
    });
  }

  @override
  Widget build(BuildContext contextBottomNavigator) {
    List Contents = [
      Home(),
      Inventory(),
      AssetsManagment(),
      ClientMachines(),
      Notifications(),
      Setting(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Contents.elementAt(_selectedIndex),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
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
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
