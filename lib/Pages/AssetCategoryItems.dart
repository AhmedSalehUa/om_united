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
import '../FormPages/AddAsset.dart';
import '../Fragments/MobileFragment.dart';
import '../Fragments/WebFragment.dart';
import '../ListItems/AssetsCategoryListItem.dart';
import '../Components/Widgets.dart';
import 'package:http/http.dart' as http;
import '../ListItems/AssetsListItem.dart';
import 'AssetsDetails.dart';
import 'Inventory.dart';
import '../Fragments/MiniFragmnet.dart';

class AssetCategoryItems extends StatefulWidget {
  final AssetsCategory item;

  const AssetCategoryItems({Key? key, required this.item}) : super(key: key);

  @override
  State<AssetCategoryItems> createState() => _AssetCategoryItemsState();
}

class _AssetCategoryItemsState extends State<AssetCategoryItems> {


  @override
  Widget build(BuildContext context) {
    return MiniFragmnet(
      content: Details(
        item: widget.item,
      ),
    );
  }
}

class Details extends StatefulWidget {
  final AssetsCategory item;

  const Details({Key? key, required this.item })
      : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int numOfAssetsCount = 0;
  int amountOfAssetsCount = 0;

  void setCount(numOfAssets, amountOfAssets) {
    setState(() {
      numOfAssetsCount = numOfAssets;
      amountOfAssetsCount = amountOfAssets;
    });
  }
  Future<void> Delete() async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${URL_PROVIDER()}/Machines.php"),
    );
    request.fields.addAll({
      "id": widget.item.id.toString(),
      "delete": "true",
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var res = json.decode(await response.stream.bytesToString());
      if (res["error"]) {
        Fluttertoast.showToast(
            msg: res["message"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP_RIGHT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Inventory()));
        Fluttertoast.showToast(
            msg: res["message"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP_RIGHT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
        msg: "NetworkError",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  late Future<List<Assets>> _futureItems;

  Future<List<Assets>> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse("${URL_PROVIDER()}/Assets.php?category_id=" +
              widget.item.id.toString()),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      final jsonData = jsonDecode(response.body);
      var statics = jsonData["statics"];
      setCount(int.parse(statics[0]["count"]),int.parse(statics[0]["value"]));
      final List<Assets> items = [];
      for (var itemJson in jsonData["data"]) {
        final item = Assets.fromJson(itemJson);
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

  void addAssets() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddAsset(category: widget.item)));
    if (result == "done") {
      setState(() {
        _futureItems = fetchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SubHeader(
          item: widget.item,
          addAssets: addAssets,
          amountOfAssets: amountOfAssetsCount,
          numOfAssets: numOfAssetsCount,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(0),
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
                                  : MediaQuery.of(context).size.height * .4,
                              child: FutureBuilder<List<Assets>>(
                                future: _futureItems,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final items = snapshot.data!;
                                    return GridView.builder(
                                      physics: ScrollPhysics(),
                                      itemCount: items.length,
                                      cacheExtent: 9999,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: kIsWeb ? 200 : 170,
                                        crossAxisCount: kIsWeb
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width ~/
                                                280
                                            : 2,
                                        crossAxisSpacing: kIsWeb ? 90 : 20,
                                      ),
                                      itemBuilder: (context, index) {
                                        final item = items[index];
                                        return GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AssetsDetails(
                                                          item: item,
                                                        )));
                                            if (result == "done") {
                                              setState(() {
                                                _futureItems = fetchData();
                                              });
                                            }
                                          },
                                          child: AssetsListItem(
                                            item: item,
                                          ),
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
    );
  }
}

class SubHeader extends StatefulWidget {
  final AssetsCategory item;
  final Function() addAssets;
  final int numOfAssets;
  final int amountOfAssets;

  const SubHeader(
      {Key? key,
      required this.item,
      required this.addAssets,
      required this.amountOfAssets,
      required this.numOfAssets})
      : super(key: key);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          subHeaderButton(kIsWeb ? 'اضافة اصل' : '', PhosphorIcons.plus_circle,
              () {
            widget.addAssets();
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'ادارة الاصول (${widget.item.name})',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: kIsWeb ? 32 : 16,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      PhosphorIcons.arrow_right,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: 'عودة',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "اجمالي عدد ${widget.item.name} (${widget.numOfAssets})",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF98A1B2),
                    fontSize: 14,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "اجمالي قيمة ${widget.item.name} (${widget.amountOfAssets})",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF98A1B2),
                    fontSize: 14,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
