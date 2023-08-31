import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/ListItems/MachineItem.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/Pages/MachineDetails.dart';

import 'package:http/http.dart' as http;
import 'package:om_united/SubHeader/SearchResultSubHeader.dart';
import '../utilis/Utilis.dart';
import 'MainFragmnet.dart';

class SearchResult extends StatefulWidget {
  final String SearchKey;
  const SearchResult({Key? key,required this.SearchKey}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultPage();
}

class _SearchResultPage extends State<SearchResult> {

  @override
  Widget build(BuildContext context) {
    // return InventoryPageContent(onChanged: _updateChildWidgetState);
    return MainFragmnet(
      isMainWidget: false,
      subHeader: SearchResultSubHeader(
       searchText: widget.SearchKey,
      ),
      content: SearchResultContent(SearchKey: widget.SearchKey,),
    );
  }
}

class SearchResultContent extends StatefulWidget {

  final String SearchKey;
  const SearchResultContent({Key? key,required this.SearchKey})
      : super(key: key);

  @override
  State<SearchResultContent> createState() => _SearchResultContent();
}

class _SearchResultContent extends State<SearchResultContent> {
  String selectedFilter = "all";
  late Future<List<Machine>> _futureItems;
  Future<List<Machine>> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse("${URL_PROVIDER()}/Machines.php?status=$selectedFilter&key=${widget.SearchKey}"),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              listFilter("المعطل", PhosphorIcons.link_break, () {
                setState(() {
                  selectedFilter = "crashed";  _futureItems = fetchData();
                });
              }, selectedFilter == "crashed"),
              const SizedBox(
                width: 10,
              ),
              listFilter("المؤجر", PhosphorIcons.identification_badge,
                      () {
                    setState(() {
                      selectedFilter = "rents";  _futureItems = fetchData();
                    });
                  }, selectedFilter == "rents"),
              const SizedBox(
                width: 10,
              ),
              listFilter("فى المخزن", PhosphorIcons.storefront, () {
                setState(() {
                  selectedFilter = "inventory";  _futureItems = fetchData();
                });
              }, selectedFilter == "inventory"),
              const SizedBox(
                width: 10,
              ),
              listFilter("الكل", PhosphorIcons.cube, () {
                setState(() {
                  selectedFilter = "all"; _futureItems = fetchData();
                });
              }, selectedFilter == "all"),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .6,
            child: FutureBuilder<List<Machine>>(
              future: _futureItems,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final items = snapshot.data!;
                  return GridView.builder(
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                        MediaQuery.of(context).size.width ~/ 280,
                        crossAxisSpacing: 90,
                        mainAxisSpacing: 30),
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
