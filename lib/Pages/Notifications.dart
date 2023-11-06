import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:om_united/ListItems/AlertMaintainceItem.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ListItems/NotificationItem.dart';
import '../utilis/Utilis.dart';
import '../SubHeader/MainPageSubHeader.dart';
import 'package:http/http.dart' as http;

import 'Maintaince.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String numOfNotifictaions = "";

  void setNumber(num) {
    setState(() {
      numOfNotifictaions = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          NotificationsSubHeader(numOfNotifictaions: numOfNotifictaions),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.only(bottom: 5),
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
                        child: NotificationsContent(
                          setNum: setNumber,
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

class NotificationsContent extends StatefulWidget {
  final Function(String)? setNum;

  const NotificationsContent({Key? key, this.setNum}) : super(key: key);

  @override
  State<NotificationsContent> createState() =>
      _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  List<Machine> _notificationList = [];
  List<Machine> _rentSoonList = [];

  String numOfNotifictaions = "";

  void fetchData() async {
    try {
      final response = await http.get(
          Uri.parse("${URL_PROVIDER()}/Machines.php?notifications=true"),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      final jsonData = jsonDecode(response.body);
      final List<Machine> lateMaibntaince = [];
      var dataJS = jsonData["data"];
      for (var itemJson in dataJS['notifications']) {
        final item = Machine.fromJson(itemJson);
        lateMaibntaince.add(item);
      }

      final List<Machine> rentSoon = [];

      for (var itemJson in dataJS['rentSoon']) {
        final item = Machine.fromJson(itemJson);
        rentSoon.add(item);
      }
      setState(() {
        _notificationList = lateMaibntaince;
        _rentSoonList = rentSoon;
        numOfNotifictaions = "الاشعارات (${lateMaibntaince.length})";
        !kIsWeb
            ? widget.setNum!("الاشعارات (${lateMaibntaince.length})")
            : null;
      });
    } catch (e) {
      print("excep ${e}");
      setState(() {
        numOfNotifictaions = "الاشعارات (0)";
      });
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> Noties = [
      kIsWeb
          ? Align(
              alignment: Alignment.centerRight,
              child: Text(
                 '$numOfNotifictaions'  ,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF1A1A24),
                  fontSize: 20,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : SizedBox(),
      SizedBox(
        height: (_notificationList.length * 80),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _notificationList.length,
          cacheExtent: 9999,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MaintaincePage(
                              item: _notificationList[index],
                            )));
              },
              child: ListTile(
                title: NotificationItem(machine: _notificationList[index]),
              ),
            );
          },
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text("ينتهي ايجاره قريبا"),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: (_rentSoonList.length * 80),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _rentSoonList.length,
          cacheExtent: 9999,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MaintaincePage(
                              item: _rentSoonList[index],
                            )));
              },
              child: ListTile(
                title: NotificationItem(machine: _rentSoonList[index],visible:false),
              ),
            );
          },
        ),
      )
    ];
    Widget content = Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0x14344054)),
          borderRadius: BorderRadius.circular(21),
        ),
      ),
      padding: kIsWeb ? const EdgeInsets.all(16) : const EdgeInsets.all(5),
      child: Column(
        children: Noties,
      ),
    );
    return kIsWeb ? content : content;
  }
}

class NotificationsSubHeader extends StatefulWidget {
  final String numOfNotifictaions;

  const NotificationsSubHeader({Key? key, required this.numOfNotifictaions})
      : super(key: key);

  @override
  State<NotificationsSubHeader> createState() =>
      _NotificationsSubHeaderState();
}

class _NotificationsSubHeaderState
    extends State<NotificationsSubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 60, 15, 15),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.numOfNotifictaions,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'santo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
