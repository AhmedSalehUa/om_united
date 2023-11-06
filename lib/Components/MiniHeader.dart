import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/Model/User.dart';
import 'package:om_united/Pages/ClientMachines.dart';
import 'package:om_united/Pages/Home.dart';
import 'package:om_united/Pages/Inventory.dart';
import 'package:om_united/Pages/SearchResult.dart';
import 'package:om_united/Pages/Setting.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentications/Login.dart';
import '../Pages/Notifications.dart';

class MiniHeader extends StatefulWidget {


  const MiniHeader({Key? key,  }) : super(key: key);

  @override
  State<MiniHeader> createState() => _MiniHeaderState();
}

class _MiniHeaderState extends State<MiniHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RawMaterialButton(
          onPressed: () {
            showPopover(
              context: context,
              bodyBuilder: (context) => const ListItems(),
              direction: PopoverDirection.bottom,
              width: 200,
              height: 100,
              arrowHeight: 0,
              arrowWidth: 0,
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
                  child: const NotificationsContent()),
              direction: PopoverDirection.bottom,
              width: 385,
              height: 492,
              arrowHeight: 0,
              arrowWidth: 0,
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

      ],
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
            ()   {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Setting(
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
