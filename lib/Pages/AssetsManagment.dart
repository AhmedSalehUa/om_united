import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Model/AssetsCategory.dart';
import 'package:http/http.dart' as http;
import '../Components/CustomAlertDialog.dart';
import '../Components/Widgets.dart';
import '../FormPages/AddAssetsCategory.dart';
import '../FormPages/AddMachine.dart';
import '../Fragments/MobileFragment.dart';
import '../Fragments/WebFragment.dart';
import '../ListItems/AssetsCategoryListItem.dart';
import '../utilis/Utilis.dart';
import 'AssetCategoryItems.dart';
import 'AssetsCategoryDetails.dart';

class AssetsManagment extends StatefulWidget {
  const AssetsManagment({super.key});

  @override
  State<AssetsManagment> createState() => _AssetsManagmentState();
}

class _AssetsManagmentState extends State<AssetsManagment> {
  int numOfAssetsCount = 0;
  int amountOfAssetsCount = 0;

  void setCount(numOfAssets, amountOfAssets) {
    setState(() {
      numOfAssetsCount = numOfAssets;
      amountOfAssetsCount = amountOfAssets;
    });
  }

  @override
  void initState() {
    super.initState();
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
          SubHeader(
              amountOfAssets: amountOfAssetsCount,
              numOfAssets: numOfAssetsCount),
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
                        child: Content(setCounter: setCount))
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

class Content extends StatefulWidget {
  final void Function(int, int) setCounter;

  const Content({super.key, required this.setCounter});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  late Future<List<AssetsCategory>> _futureItems;

  Future<List<AssetsCategory>> fetchData() async {
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
      var statics  = jsonData["statics"];
      widget.setCounter(int.parse(statics[0]["count"]),int.parse(statics[0]["value"]));
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
          Expanded(
            child: SizedBox(
              height: kIsWeb
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.height * .4,
              child: FutureBuilder<List<AssetsCategory>>(
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
                        crossAxisCount: kIsWeb ? 4 : 2,
                        crossAxisSpacing: kIsWeb ? 190 : 120,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AssetCategoryItems(
                                          item: item,
                                        )));

                              setState(() {
                                _futureItems = fetchData();
                              });
                          },
                          onLongPress: ()async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AssetsCategoryDetails(
                                      item: item,
                                    )));
                            if(result=="done") {
                              setState(() {
                                _futureItems = fetchData();
                              });
                            }
                          },
                          child: AssetsCategoryListItem(
                            item: item ,
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
  final int numOfAssets;
  final int amountOfAssets;

  SubHeader(
      {super.key, required this.amountOfAssets, required this.numOfAssets});

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
          subHeaderButton(
              kIsWeb ? 'اضافة تصنيف' : '', PhosphorIcons.plus_circle, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddAssetsCategory()));
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "ادارة الاصول",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: kIsWeb ? 32 : 16,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "اجمالي عدد الاصول (${widget.numOfAssets})",
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
                  "اجمالي قيمة الاصول (${widget.amountOfAssets})",
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
