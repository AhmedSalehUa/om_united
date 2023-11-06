import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:om_united/FormPages/EditAssetsCategory.dart';
import 'package:om_united/ListItems/ClientRentItem.dart';
import 'package:om_united/ListItems/MaintainceItem.dart';
import 'package:om_united/Model/Assets.dart';
import 'package:om_united/Model/AssetsCategory.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/Model/Maintaince.dart';
import 'package:om_united/FormPages/EditMachine.dart';
import 'package:om_united/utilis/Utilis.dart';

import '../Components/CustomAlertDialog.dart';
import '../Fragments/MobileFragment.dart';
import '../Fragments/WebFragment.dart';
import '../ListItems/MachineItem.dart';
import '../Components/Widgets.dart';
import 'package:http/http.dart' as http;
import 'Inventory.dart';
import '../Fragments/MiniFragmnet.dart';

class AssetsCategoryDetails extends StatefulWidget {
  final AssetsCategory item;

  const AssetsCategoryDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<AssetsCategoryDetails> createState() => _AssetsCategoryDetailsState();
}

class _AssetsCategoryDetailsState extends State<AssetsCategoryDetails> {
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

  const Details({Key? key, required this.item}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Future<void> Delete() async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${URL_PROVIDER()}/AssetsCategory.php"),
    );
    request.fields.addAll({
      "id": widget.item.id.toString(),
      "delete": "true",
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var resOr = await response.stream.bytesToString();
      print(resOr);
      if (resOr.contains("Cannot delete or update a parent row")) {
        Fluttertoast.showToast(
            msg: "يوجد بيانات مضافة على التصنيف",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP_RIGHT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        var res = json.decode(resOr);
        if (res["error"]) {
          Fluttertoast.showToast(
              msg: res["message"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP_RIGHT,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Navigator.pop(
            context,
            "done",
          );
          Fluttertoast.showToast(
              msg: res["message"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP_RIGHT,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "NetworkError",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }


  void EditFunc() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditAssetsCategory(item: widget.item)));
    if (result == "done") {
      Navigator.pop(context, "done");
    }
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> detailsContent = [
      Expanded(
        flex: kIsWeb ? 2 : 1,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Text(
                  widget.item.name,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF1A1A24),
                    fontSize: 22,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Container(
                  width: 230,
                  decoration: ShapeDecoration(
                    color: widget.item.forRent == "true"
                        ? Colors.green
                        : Color(0xFF475467),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 2, color: Color(0x14344054)),
                      borderRadius: BorderRadius.circular(21),
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    widget.item.forRent == "true"
                        ? "  متاح للتاجير : متاح" : "  متاح للتاجير : غير متاح"   ,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Expanded(
        flex: kIsWeb ? 1 : 0,
        child: Stack(
          children: [
            Container(
              height: 380,
              width: MediaQuery.of(context).size.width,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0xFFD0D5DD)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: CachedNetworkImage(
                imageUrl: widget.item.image ??
                    "https://media.istockphoto.com/id/182192586/photo/portable-electric-generator.jpg?s=612x612&w=0&k=20&c=xQzHBE_g29RdGV-AZbqek0JQzHifxOD-z3lExi1MfDs=",
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Container(
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(6),
                decoration: ShapeDecoration(
                  color: const Color(0xFF475467),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: Text(
                  "#${widget.item.id.toString()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SubHeader(
          item: widget.item,
          Delete: Delete,Edit: EditFunc
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
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: kIsWeb
                                  ? Row(
                                      children: detailsContent,
                                    )
                                  : Column(
                                      verticalDirection: VerticalDirection.up,
                                      children: detailsContent,
                                    ),
                            ),
                          ],
                        ),
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
  final Function Delete;
  final Function Edit;
  final AssetsCategory item;

  const SubHeader({Key? key, required this.Delete, required this.Edit, required this.item})
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
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'تفاصيل التصنيف (${widget.item.name})',
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
          Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              children: [
                subHeaderButton(
                  kIsWeb ? 'تعديل التصنيف' : '',
                  PhosphorIcons.pencil_simple,
                  () {
                   widget.Edit();
                  },
                  color: const Color.fromRGBO(205, 230, 244, 1),
                ),
                const SizedBox(
                  width: 10,
                ),
                subHeaderButton(
                  '',
                  PhosphorIcons.trash,
                  () {
                    showDialog(
                      barrierColor: Colors.black26,
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          title: "هل انت متأكد من رغبتك في حذف التصنيف",
                          description: "لن تستطيع اعادته مرة أخرى",
                          onConfirm: () {
                            widget.Delete();
                          },
                        );
                      },
                    );
                  },
                  color: const Color.fromRGBO(249, 213, 218, 1),
                  shadow: const Color(0x4CF9D5DA),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
