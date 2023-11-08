import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Model/Assets.dart';

class AssetsMultiListItem extends StatefulWidget {
  final Assets item;
  bool? selected;

  AssetsMultiListItem({Key? key, required this.item, this.selected})
      : super(key: key);

  @override
  State<AssetsMultiListItem> createState() => _AssetsMultiListItemState();
}

class _AssetsMultiListItemState extends State<AssetsMultiListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: widget.selected != null
            ? widget.selected!
                ? Colors.green
                : Colors.white
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      margin: EdgeInsets.only(top: 10),
      child: Wrap(
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
                          height: kIsWeb ? 140 : 100,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.50, color: Color(0xFFD0D5DD)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.item.image,
                            fit: BoxFit.fill,
                          ),
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
                        '#${widget.item.code.toString()}',
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
                    style: TextStyle(
                      color: widget.selected != null
                          ? widget.selected!
                              ? Colors.white
                              : Color(0xFF1A1A24)
                          : Color(0xFF1A1A24),
                      fontSize: 16,
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
    );
  }
}
