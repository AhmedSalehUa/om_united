import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:om_united/ListItems/AlertMaintainceItem.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilis/Utilis.dart';
import '../SubHeader/MainPageSubHeader.dart';
import 'package:http/http.dart' as http;
import 'package:om_united/Model/User.dart';

import 'Maintaince.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

String UserName = "";

class _HomeState extends State<Home> {
  Future<String> Initialize() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('email');

    final String url = '${URL_PROVIDER()}/Auth.php';

    Map<String, String> data;
    if (!kIsWeb) {
      data = {'email': action!, 'token': prefs.getString("token")!};
    } else {
      data = {'email': action!};
    }
    final response = await http.post(
      Uri.parse(url),
      body: data,
    );
    if (response.statusCode == 200) {

      return prefs.getString('userName')!;
    } else {
      // print('Error loggin user');
      return " ";
    }
  }

  @override
  void initState() {
    super.initState();
    if (UserName == "") {
      Initialize().then((value) {
        setState(() {
          UserName = value;
        });
      });
    }
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
          MainPageSubHeader(
            name: UserName,
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
                        hasScrollBody: false, child:HomeContent())
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

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Machine> _lateMaintaince = [];
  List<Machine> _soonMaintaince = [];

  void fetchData() async {
    try {
      final response = await http.get(
          Uri.parse("${URL_PROVIDER()}/Machines.php?situation=true"),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      final jsonData = jsonDecode(response.body);
      final List<Machine> lateMaibntaince = [];
      var dataJson = jsonData["data"];
      for (var itemJson in dataJson['late']) {
        final item = Machine.fromJson(itemJson);
        lateMaibntaince.add(item);
      }

      final List<Machine> sonnMaintaince = [];
      for (var itemJson in dataJson['soon']) {
        final item = Machine.fromJson(itemJson);
        sonnMaintaince.add(item);
      }
      int numOfInventoryI =0;
      int numOfCrashedI = 0;
      int numOfRentsI =   0;
      dataJson['statics'].forEach((e){
        numOfInventoryI = e["1"]!=null?int.parse(e["1"]):numOfInventoryI;
        numOfCrashedI = e["2"]!=null?int.parse(e["2"]):numOfCrashedI;
        numOfRentsI = e["3"]!=null?int.parse(e["3"]):numOfRentsI;
      });

      setState(() {
        numOfInventory = numOfInventoryI;
        numOfCrashed = numOfCrashedI;
        numOfRents = numOfRentsI;
        numOfMachine = numOfInventoryI +
            numOfCrashedI +
            numOfRentsI;

        _lateMaintaince = lateMaibntaince;
        _soonMaintaince = sonnMaintaince;
      });
    } catch (e) {
      print("excep ${e}");
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  int numOfMachine = 0;
  int numOfInventory = 0;
  int numOfRents = 0;
  int numOfCrashed = 0;

  @override
  Widget build(BuildContext context) {
    Widget static = Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0x14344054)),
          borderRadius: BorderRadius.circular(21),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '($numOfMachine)',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 16,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'الماكينات',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF1A1A24),
                  fontSize: 16,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: numOfMachine!=0? (numOfInventory / numOfMachine * 100).toInt():1,
                child: Container(
                  height: 8,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF16CF85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              Flexible(
                flex: numOfMachine!=0? (numOfCrashed / numOfMachine * 100).toInt():1,
                child: Container(
                  height: 8,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE02F46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              Flexible(
                flex:  numOfMachine!=0?(numOfRents / numOfMachine * 100).toInt():1,
                child: Container(
                  height: 8,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2F68EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'المخزون',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF475467),
                          fontSize: 12,
                          fontFamily: 'santo',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.50,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: ShapeDecoration(
                          color: Color(0xFF16CF85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    numOfInventory.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF1A1A24),
                      fontSize: 16,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.15,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'المعطل',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF475467),
                          fontSize: 12,
                          fontFamily: 'santo',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.50,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: ShapeDecoration(
                          color: Color(0xFFE02F46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    numOfCrashed.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF1A1A24),
                      fontSize: 16,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.15,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'المؤجر',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF475467),
                          fontSize: 12,
                          fontFamily: 'santo',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.50,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: ShapeDecoration(
                          color: Color(0xFF2F68EE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    numOfRents.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF1A1A24),
                      fontSize: 16,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.15,
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
    List<Widget> content = [
      kIsWeb
          ? Expanded(
              flex: 2,
              child: static,
            )
          : static,
      kIsWeb
          ? const SizedBox(
              width: 24,
            )
          : const SizedBox(
              height: 24,
            ),
      Expanded(
        flex: 4,
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0x14344054)),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
          padding: kIsWeb ? const EdgeInsets.all(16) : const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'صيانة الماكينات',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF1A1A24),
                  fontSize: 16,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
              _lateMaintaince.length>0? Text(
                'المتأخر صيانته',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 14,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ):SizedBox(),
              SizedBox(
                height: (_lateMaintaince.length * 80),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _lateMaintaince.length,
                  cacheExtent: 9999,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MaintaincePage(
                                      item: _lateMaintaince[index],
                                    )));
                      },
                      child: ListTile(
                        title: AlertMaintainceItem(
                            machine: _lateMaintaince[index]),
                      ),
                    );
                  },
                ),
              ),
              _soonMaintaince.length >0 ? Text(
                'صيانته قريباً',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 14,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ):SizedBox(),
              SizedBox(
                height: (_soonMaintaince.length * 80),
                child: ListView.builder(
                  itemCount: _soonMaintaince.length,
                  cacheExtent: 9999,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MaintaincePage(
                                      item: _soonMaintaince[index],
                                    )));
                      },
                      child: ListTile(
                        title: AlertMaintainceItem(
                            machine: _soonMaintaince[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    return kIsWeb
        ? Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: content,
              ),
            ],
          )
        : Column(
            children: content,
          );
  }
}
