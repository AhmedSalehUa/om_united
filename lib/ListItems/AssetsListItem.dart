import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Model/Assets.dart';

class AssetsListItem extends StatefulWidget {
  final Assets item;

  const AssetsListItem(
      {Key? key,
      required this.item })
      : super(key: key);

  @override
  State<AssetsListItem> createState() => _AssetsListItemState();
}

class _AssetsListItemState extends State<AssetsListItem> {


  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: kIsWeb?140: 100,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.50, color: Color(0xFFD0D5DD)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.item.image,
                          fit: BoxFit.fill,
                        )  ,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(6),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF475467),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Text(
                      '#${widget.item.id.toString()}',
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
            Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,

                child: Text(
                  widget.item.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1A1A24),
                    fontSize: 16,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    side:
                    const BorderSide(width: 2, color: Color(0x14344054)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: EdgeInsets.only(left: 5,right: 5),
                child: Text(
                  "قيمة الاصل : " + widget.item.value.toString() + " ريال ",
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),
                ),
              ),
            )

          ],
        ),
      ],
    );
  }
}