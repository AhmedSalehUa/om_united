import 'dart:convert';

 import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/ListItems/MachineItem.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/Pages/MachineDetails.dart';
import 'package:om_united/SubHeader/InventorySubHeader.dart';

import 'package:http/http.dart' as http;
import 'package:om_united/utilis/Utilis.dart';
 import 'MainFragmnet.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPage();
}

class _InventoryPage extends State<InventoryPage> {
  bool _isAddVisible = true;

  void _updateChildWidgetState(bool isOn) {
    setState(() {
      _isAddVisible = isOn;
    });
  }

  int count = 0;

  void setCount(co) {
    setState(() {
      count = co;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return InventoryPageContent(onChanged: _updateChildWidgetState);
    return MainFragmnet(
      selectedIndex : 1,
      isMainWidget: false,
      subHeader: InventorySubHeader(
        isAddvisible: _isAddVisible,
        totalItems: count,
      ),
      content: InventoryPageContent(
          onChanged: _updateChildWidgetState, setCounter: setCount),
    );
  }
}

class InventoryPageContent extends StatefulWidget {
  final void Function(bool)? onChanged;
  final void Function(int)? setCounter;

  const InventoryPageContent(
      {Key? key, required this.onChanged, required this.setCounter})
      : super(key: key);

  @override
  State<InventoryPageContent> createState() => _InventoryPageContent();
}

class _InventoryPageContent extends State<InventoryPageContent> {
  String selectedFilter = "all";
  late Future<List<Machine>> _futureItems;

  Future<List<Machine>> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse("${URL_PROVIDER()}/Machines.php?status=$selectedFilter"),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      final jsonData = jsonDecode(response.body);
      final List<Machine> items = [];

      for (var itemJson in jsonData) {

        final item = Machine.fromJson(itemJson);

        items.add(item);
      }

      widget.setCounter!(items.length);

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
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                verticalDirection: VerticalDirection.down,
                children: [
                  listFilter("المعطل", PhosphorIcons.link_break, () {
                    setState(() {
                      widget.onChanged?.call(false);
                      selectedFilter = "crashed";
                      _futureItems = fetchData();
                    });
                  }, selectedFilter == "crashed"),
                  const SizedBox(
                    width: 10,
                  ),
                  listFilter("المؤجر", PhosphorIcons.identification_badge, () {
                    setState(() {
                      widget.onChanged?.call(false);
                      selectedFilter = "rents";
                      _futureItems = fetchData();
                    });
                  }, selectedFilter == "rents"),
                  const SizedBox(
                    width: 10,
                  ),
                  listFilter("فى المخزن", PhosphorIcons.storefront, () {
                    setState(() {
                      widget.onChanged?.call(false);
                      selectedFilter = "inventory";
                      _futureItems = fetchData();
                    });
                  }, selectedFilter == "inventory"),
                  const SizedBox(
                    width: 10,
                  ),
                  listFilter("الكل", PhosphorIcons.cube, () {
                    setState(() {
                      widget.onChanged?.call(true);
                      selectedFilter = "all";
                      _futureItems = fetchData();
                    });
                  }, selectedFilter == "all"),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *.45  ,
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
                        crossAxisSpacing: kIsWeb ? 90 : 20, ),
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
                          id: "#${item.id}",
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
          )
        ],
      ),
    );
  }
}