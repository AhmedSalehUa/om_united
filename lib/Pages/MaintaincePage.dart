
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/ListItems/ClientRentItem.dart';
import 'package:om_united/ListItems/MaintainceItem.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/Model/Maintaince.dart';
import 'package:om_united/Pages/AddMaintaince.dart';
import 'package:om_united/utilis/Utilis.dart';

import '../Components/Header.dart';
import '../ListItems/MachineItem.dart';
import '../Components/Widgets.dart';
import 'MiniFragmnet.dart';

class MaintaincePage extends StatefulWidget {
  final Machine item;

  const MaintaincePage({Key? key, required this.item}) : super(key: key);

  @override
  State<MaintaincePage> createState() => _MaintaincePageState();
}

class _MaintaincePageState extends State<MaintaincePage> {
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
  final Machine item;

  const Details({Key? key, required this.item}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {List<Maintaince> listMaintainces =
  widget.item.mainainces != null ? widget.item.mainainces! : [];
  List<Widget> mainainces = listMaintainces
      .map((item) => MaintainceItem(
    maintaince: item,
    machine: widget.item,
  ))
      .toList();
  List<Widget> detailsContent = [
    Expanded(
      flex: kIsWeb ? 2 : 1,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              child: Text(
                widget.item.brand == null ? "الماركة" : " الماركة : "+ widget.item.brand!,
                textAlign: TextAlign.right,textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 14,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Text(
                widget.item.code == null ? "الرقم التعريفي" :   " الرقم التعريفي : "+widget.item.code!,
                textAlign: TextAlign.right,textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 14,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Container(
                width: 150,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side:
                    const BorderSide(width: 2, color: Color(0x14344054)),
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: StatusItem(
                  state: widget.item.status,
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
                  shape: RoundedRectangleBorder(
                    side:
                    const BorderSide(width: 2, color: Color(0x14344054)),
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: Text( "اجمالي تكلفة الصيانة : " + widget.item.total_maintance_cost.toString() , textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF475467),
                    fontSize: 14,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),),
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
                  shape: RoundedRectangleBorder(
                    side:
                    const BorderSide(width: 2, color: Color(0x14344054)),
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: Text( "قيمة المولد : " + widget.item.machine_value.toString() , textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl, style: const TextStyle(
                    color: Color(0xFF475467),
                    fontSize: 14,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            widget.item.rent != null
                ? ClientRentItem(
              rent: widget.item.rent!,
            )
                : kIsWeb
                ? const SizedBox(
              height: 100,
            )
                : const SizedBox(),
            kIsWeb
                ? const SizedBox()
                : const SizedBox(
              height: 10,
            ),
            getMachineStatus(
                widget.item.lastMaintaince!, widget.item.maintainceEvery),
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
        children: [ Container(
          height: 380,width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0xFFD0D5DD)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: EdgeInsets.all(10),
          child: CachedNetworkImage(
            imageUrl: widget.item.imageUrl ??
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
                "#${widget.item.serial.toString()}",
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
      kIsWeb
          ? const Header(
        isMain: false,
      )
          : SizedBox(),
      SubHeader(
        item: widget.item,
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
                          mainainces.length>0 ?const Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Text(
                              'تاريخ الصيانة',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF1A1A24),
                                fontSize: 16,
                                fontFamily: 'santo',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.15,
                              ),
                            ),
                          ):SizedBox(),
                          Expanded(
                            flex: kIsWeb?1:0,
                            child: Column(
                              children: mainainces,
                            ),
                          )
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
  final Machine item;

  const SubHeader({Key? key, required this.item}) : super(key: key);

  @override
  State<SubHeader> createState() => _SubHeaderState();
}

class _SubHeaderState extends State<SubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(

      padding:kIsWeb ? const EdgeInsets.all(15): const EdgeInsets.fromLTRB(15, 50, 15, 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'صيانة المنتج',
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
                kIsWeb
                    ? subHeaderButton(
                        'صيانة المنتج',
                        PhosphorIcons.wrench,
                        onMaintainceTap,
                        color: const Color.fromRGBO(205, 230, 244, 1),
                      )
                    : subHeaderButton(
                        '', PhosphorIcons.wrench, onMaintainceTap),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onMaintainceTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddMaintaince(
                  item: widget.item,
                )));
  }
}
