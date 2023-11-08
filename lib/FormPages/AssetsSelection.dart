import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:om_united/Model/Assets.dart';
import 'package:om_united/Model/AssetsCategory.dart';
import 'package:om_united/utilis/Utilis.dart';

import '../Components/CustomAlertDialog.dart';
import '../ListItems/AssetsCategoryMiniListItem.dart';
import '../ListItems/AssetsMultiListItem.dart';
import 'AddAsset.dart';
import '../Fragments/MobileFragment.dart';
import '../Fragments/WebFragment.dart';
import '../ListItems/AssetsCategoryListItem.dart';
import '../Components/Widgets.dart';
import 'package:http/http.dart' as http;
import '../ListItems/AssetsListItem.dart';
import '../Pages/AssetsDetails.dart';
import '../Pages/Inventory.dart';
import '../Fragments/MiniFragmnet.dart';

class AssetsSelection extends StatefulWidget {
  final List<Assets> list;

  const AssetsSelection({Key? key, required this.list}) : super(key: key);

  @override
  State<AssetsSelection> createState() => _AssetsSelectionState();
}

class _AssetsSelectionState extends State<AssetsSelection> {
  @override
  Widget build(BuildContext context) {
    return MiniFragmnet(
      content: Details(list: widget.list),
    );
  }
}

class Details extends StatefulWidget {
  final List<Assets> list;

  const Details({Key? key, required this.list}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String selectedFilter = "0";
  String filterName = "";
  late Future<List<Assets>> _futureItems;
  List<Assets> _allAssets = [];
  List<MultiSelectItem<Assets>> listItems = <MultiSelectItem<Assets>>[];
  List<int> selectedCount = [];

  late Future<List<AssetsCategory>> _futureCategory;

  Future<List<AssetsCategory>> fetchCategory() async {
    try {
      final response = await http
          .get(Uri.parse("${URL_PROVIDER()}/AssetsCategory.php"), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      final jsonData = jsonDecode(response.body);
      final List<AssetsCategory> items = [];
      for (var itemJson in jsonData["data"]) {
        final item = AssetsCategory.fromJson(itemJson);
        items.add(item);
      }
      return items;
    } catch (e) {
      print("excep ${e}");
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<Assets>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse("${URL_PROVIDER()}/Assets.php"), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      final jsonData = jsonDecode(response.body);

      final List<Assets> items = [];
      for (var itemJson in jsonData["data"]) {
        final item = Assets.fromJson(itemJson);
        if (filterName != "") {
          if (selectedFilter == "0" &&
              (item.name.contains(filterName) ||
                  item.code.contains(filterName))) {
            items.add(item);
          } else {
            if (item.category_id == int.parse(selectedFilter) &&
                (item.name.contains(filterName) ||
                    item.code.contains(filterName))) {
              items.add(item);
            }
          }
        } else {
          if (selectedFilter == "0") {
            items.add(item);
          } else {
            if (item.category_id == int.parse(selectedFilter)) {
              items.add(item);
            }
          }
        }
      }

      if (_allAssets.length == 0) {
        _allAssets.addAll(items);
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
    _futureCategory = fetchCategory();
    widget.list.forEach((element) {
      selectedCount.add(element.id);
    });
    print("initState");
    print("selectedCount");
    print(selectedCount);
  }

  void addAssets() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: const ShapeDecoration(
        color: Color(0xFF344054),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50, color: Color.fromRGBO(52, 64, 84, 1)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 254,
                    height: 36,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF344054),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.50, color: Color.fromRGBO(52, 64, 84, 1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        onSubmitted: (a) {
                          setState(() {
                            filterName = a;
                            _futureItems = fetchData();
                          });
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
                 kIsWeb? Padding(padding: EdgeInsets.only(top: 10,bottom: 10),
                    child: SizedBox(
                      height: 55,
                      width: (MediaQuery.of(context).size.width / 4) * 3,
                      child: FutureBuilder<List<AssetsCategory>>(
                        future: _futureCategory,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final items = snapshot.data!;
                            return GridView.builder(
                              physics: ScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: items.length,mainAxisExtent: 50),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return SizedBox(
                                  height: 45,
                                  child: CatFilter(
                                      item.name, PhosphorIcons.cube, () {
                                    setState(() {
                                      selectedFilter = item.id.toString();
                                      _futureItems = fetchData();
                                    });
                                  }, selectedFilter == item.id.toString()),
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
                  ):SizedBox(),
                  kIsWeb?CatFilter("الكل", PhosphorIcons.cube, () {
                    setState(() {
                      selectedFilter = "0";
                      _futureItems = fetchData();
                    });
                  }, selectedFilter == "0"):SizedBox(),
                ],
              ),
              Expanded(
                child: Container(
                  child: SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: Color(0x14344054)),
                                borderRadius: BorderRadius.circular(21),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: kIsWeb
                                        ? MediaQuery.of(context).size.height
                                        : MediaQuery.of(context).size.height *
                                            .4,
                                    child: FutureBuilder<List<Assets>>(
                                      future: _futureItems,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final items = snapshot.data!;
                                          // bool isListInitialized =
                                          //     listItems.isNotEmpty;
                                          // if (!isListInitialized) {
                                          listItems = snapshot.data!.map((e) {
                                            bool found = false;
                                            selectedCount.forEach((m) {
                                              print(m);
                                              if (m == e.id) {
                                                found = true;
                                              }
                                            });
                                            return MultiSelectItem(e, found);
                                          }).toList();
                                          // }
                                          return GridView.builder(
                                            physics: ScrollPhysics(),
                                            itemCount: items.length,
                                            cacheExtent: 9999,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisExtent:
                                                  kIsWeb ? 200 : 170,
                                              crossAxisCount: kIsWeb
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width ~/
                                                      280
                                                  : 2,
                                              crossAxisSpacing:
                                                  kIsWeb ? 90 : 20,
                                            ),
                                            itemBuilder: (context, index) {
                                              final item = items[index];
                                              return GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    bool found = false;
                                                    selectedCount.forEach((m) {
                                                      print(m);
                                                      if (m == item.id) {
                                                        found = true;
                                                      }
                                                    });
                                                    if (!found) {
                                                      selectedCount
                                                          .add(item.id);
                                                    } else {
                                                      selectedCount
                                                          .remove(item.id);
                                                    }
                                                    listItems[index].selected =
                                                        !listItems[index]
                                                            .selected;
                                                  });
                                                },
                                                child: getGridItem(
                                                    listItems[index], index),
                                              );
                                            },
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: FloatingActionButton(
              onPressed: () {
                print("listItems.length");
                print(listItems.length);
                print("_allAssets");
                print(_allAssets.length);
                print("selectedCount");
                print(selectedCount);

                Navigator.pop(
                    context, {"assets": _allAssets, "selected": selectedCount});
              },
              child: Text('اختيار'),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectItem<T> {
  final T value;
  bool selected;

  MultiSelectItem(this.value, this.selected);
}

Widget getGridItem(MultiSelectItem item, int index) {
  Assets product = item.value;

  return AssetsMultiListItem(item: product, selected: item.selected);
}
/*Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      listFilter("المعطل", PhosphorIcons.link_break, () {
                        setState(() {
                          selectedFilter = "6";
                          _futureItems = fetchData();
                        });
                      }, selectedFilter == "6"),
                      const SizedBox(
                        width: 10,
                      ),
                      listFilter("المؤجر", PhosphorIcons.identification_badge,
                          () {
                        setState(() {
                          selectedFilter = "7";
                          _futureItems = fetchData();
                        });
                      }, selectedFilter == "7"),
                      const SizedBox(
                        width: 10,
                      ),
                      listFilter("فى المخزن", PhosphorIcons.storefront, () {
                        setState(() {
                          selectedFilter = "2";
                          _futureItems = fetchData();
                        });
                      }, selectedFilter == "1"),
                      const SizedBox(
                        width: 10,
                      ),
                      listFilter("الكل", PhosphorIcons.cube, () {
                        setState(() {
                          selectedFilter = "0";
                          _futureItems = fetchData();
                        });
                      }, selectedFilter == "0"),
                    ],
                  ),*/
