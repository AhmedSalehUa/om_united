import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:om_united/ListItems/AlertMaintainceItem.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/Header.dart';
import '../ListItems/NotificationItem.dart';
import '../utilis/Utilis.dart';
import 'MainFragmnet.dart';
import '../SubHeader/MainPageSubHeader.dart';
import 'package:http/http.dart' as http;

import 'MaintaincePage.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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
          kIsWeb
              ? Header(
                  isMain: false,
                )
              : SizedBox(),
          NotificationsPageSubHeader(numOfNotifictaions: numOfNotifictaions),
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
                        child: NotificationsPageContent(
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
    MainFragmnet(
      selectedIndex: 2,
      isMainWidget: true,
      subHeader:
          NotificationsPageSubHeader(numOfNotifictaions: numOfNotifictaions),
      content: NotificationsPageContent(
        setNum: setNumber,
      ),
    );
  }
}

class NotificationsPageContent extends StatefulWidget {
  final Function(String)? setNum;

  const NotificationsPageContent({Key? key, this.setNum}) : super(key: key);

  @override
  State<NotificationsPageContent> createState() =>
      _NotificationsPageContentState();
}

class _NotificationsPageContentState extends State<NotificationsPageContent> {
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

      for (var itemJson in jsonData['notifications']) {
        final item = Machine.fromJson(itemJson);
        lateMaibntaince.add(item);
      }

      final List<Machine> rentSoon = [];

      for (var itemJson in jsonData['rentSoon']) {
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

class NotificationsPageSubHeader extends StatefulWidget {
  final String numOfNotifictaions;

  const NotificationsPageSubHeader({Key? key, required this.numOfNotifictaions})
      : super(key: key);

  @override
  State<NotificationsPageSubHeader> createState() =>
      _NotificationsPageSubHeaderState();
}

class _NotificationsPageSubHeaderState
    extends State<NotificationsPageSubHeader> {
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
