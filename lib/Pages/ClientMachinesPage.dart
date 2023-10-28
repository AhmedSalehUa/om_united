import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/ListItems/MachineItem.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/Model/ClientsModel.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/Pages/MachineDetails.dart';
import 'package:om_united/SubHeader/InventorySubHeader.dart';

import 'package:http/http.dart' as http;
import 'package:om_united/utilis/Utilis.dart';
import '../Components/Header.dart';
import '../ListItems/ClientDropDown.dart';
import '../ListItems/ClientDropDownCRUD.dart';
import 'MainFragmnet.dart';

class ClientMachinesPage extends StatefulWidget {
  const ClientMachinesPage({Key? key}) : super(key: key);

  @override
  State<ClientMachinesPage> createState() => _InventoryPage();
}

class _InventoryPage extends State<ClientMachinesPage> {
  @override
  Widget build(BuildContext context) {
    // return InventoryPageContent(onChanged: _updateChildWidgetState);
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
            SubHeader(),
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
                          hasScrollBody: false, child: ClientMachinesPageContent())
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
      MainFragmnet(
      selectedIndex: 1,
      isMainWidget: false,
      subHeader: SubHeader(),
      content: ClientMachinesPageContent(),
    );
  }
}

class ClientMachinesPageContent extends StatefulWidget {
  const ClientMachinesPageContent({Key? key}) : super(key: key);

  @override
  State<ClientMachinesPageContent> createState() => _InventoryPageContent();
}

class _InventoryPageContent extends State<ClientMachinesPageContent> {
  String  selectedClient="";
  late Future<List<Machine>> _futureItems;
ClientsModel? clientsModel;
  Future<List<Machine>> fetchData() async {
    try {
      final List<Machine> items = [];
      if (selectedClient!="") {
        final response = await http.get(
            Uri.parse(
                "${URL_PROVIDER()}/Machines.php?client_id=" + selectedClient!),
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*'
            });
        final jsonData = jsonDecode(response.body);

        for (var itemJson in jsonData) {
          final item = Machine.fromJson(itemJson);
          clientsModel = ClientsModel.fromJson(itemJson['Clients'][0]);
          items.add(item);
        }
      }else{
        // print(selectedClient);
      }
      return items;
    } catch (e) {
      print("excep ${e}");
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureItems = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0x14344054)),
          borderRadius: BorderRadius.circular(21),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClientDropDownCRUD(
              onChange: (value) {
                setState(() {
                  selectedClient = value.toString(); _futureItems = fetchData();
                });
              },
              onSave: (value) {
                setState(() {
                  selectedClient = value.toString(); _futureItems = fetchData();
                });
              },
              initialValue: ""),

          Expanded(
            child: SizedBox(
              height: kIsWeb
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.height * .4,
              child: FutureBuilder<List<Machine>>(
                future: _futureItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data!;
                    return GridView.builder(
                      physics: ScrollPhysics(),
                      itemCount: items.length,
                      cacheExtent: 9999,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: kIsWeb ? 200 : 170,
                        crossAxisCount: kIsWeb
                            ? MediaQuery.of(context).size.width ~/ 280
                            : 2,
                        crossAxisSpacing: kIsWeb ? 90 : 20,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MachineDetails(
                                          item: item,
                                        )));
                          },
                          child: MachineItems(
                            state: item.status,
                            name: item.name,
                            id: "#${item.serial}",
                            imageUrl:
                                item.imageUrl != null ? item.imageUrl! : "",
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SubHeader extends StatefulWidget {
  const SubHeader({Key? key}) : super(key: key);

  @override
  State<SubHeader> createState() => _SubHeaderState();
}

class _SubHeaderState extends State<SubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kIsWeb
          ? const EdgeInsets.all(15)
          : const EdgeInsets.fromLTRB(15, 50, 15, 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'المكينات المؤجرة من العميل',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: kIsWeb ? 32 : 16,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
