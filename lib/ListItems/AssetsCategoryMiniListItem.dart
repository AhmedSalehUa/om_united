import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Model/AssetsCategory.dart';

class AssetsCategoryMiniListItem extends StatefulWidget {
  final AssetsCategory item;

  const AssetsCategoryMiniListItem({Key? key, required this.item})
      : super(key: key);

  @override
  State<AssetsCategoryMiniListItem> createState() =>
      _AssetsCategoryMiniListItemState();
}

class _AssetsCategoryMiniListItemState
    extends State<AssetsCategoryMiniListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 40,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50, color: Color.fromRGBO(52, 64, 84, 1)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          child: Text(
            widget.item.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1A1A24),
              backgroundColor: Colors.white,
              fontSize: 12,
              fontFamily: 'santo',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
