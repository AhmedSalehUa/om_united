import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Model/AssetsCategory.dart';

class AssetsCategoryListItem extends StatefulWidget {
  final AssetsCategory item;

  const AssetsCategoryListItem(
      {Key? key,
      required this.item })
      : super(key: key);

  @override
  State<AssetsCategoryListItem> createState() => _AssetsCategoryListItemState();
}

class _AssetsCategoryListItemState extends State<AssetsCategoryListItem> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(flex: 1,
                    child: Container(
                      height: kIsWeb?140: 100,
                      padding: EdgeInsets.fromLTRB(20,15,20,15),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Container(
                    margin: const EdgeInsets.all(8),
                    padding:   EdgeInsets.all(widget.item.count.length<2 ? 8:4),
                    decoration: ShapeDecoration(
                      color: Colors.green,
                      shape:  CircleBorder() ),
                    child: Text(
                      widget.item.count.toString()  ,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'santo',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ), Directionality(
                    textDirection: TextDirection.rtl,
                    child: SizedBox(
                      child: Text(
                        widget.item.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF1A1A24),
                          fontSize: kIsWeb ? 24:14,
                          fontFamily: 'santo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}