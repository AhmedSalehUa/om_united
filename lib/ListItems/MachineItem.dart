import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class MachineItems extends StatefulWidget {
  final String state;
  final String name;
  final String id;
  final String imageUrl;

  const MachineItems(
      {Key? key,
      required this.state,
      required this.name,
      required this.id,
      required this.imageUrl})
      : super(key: key);

  @override
  State<MachineItems> createState() => _MachineItemsState();
}

class _MachineItemsState extends State<MachineItems> {


  @override
  Widget build(BuildContext context) {
    return Column(
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
                      imageUrl: widget.imageUrl,
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
                  widget.id,
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
              widget.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF1A1A24),
                fontSize: 14,
                fontFamily: 'santo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        StatusItem(state:  widget.state  ,)

      ],
    );
  }
}

class StatusItem extends StatefulWidget {
  final String state;
  const StatusItem({Key? key,required this.state }) : super(key: key);

  @override
  State<StatusItem> createState() => _StatusItemState();
}

class _StatusItemState extends State<StatusItem> {
  String getName(String st) {
    switch (st) {
      case "1":
        return "فى المخزن";
      case "2":
        return "معطل";
      case "3":
        return "مؤجر";
    }
    return "";
  }

  Color getColor(String st) {
    switch (st) {
      case "1":
        return const Color(0xFF068AC8);
      case "2":
        return const Color(0xFF475467);
      case "3":
        return const Color(0xFF2F68EE);
    }
    return const Color(0xFF475467);
  }

  IconData getIcon(String st) {
    switch (st) {
      case "1":
        return PhosphorIcons.storefront;
      case "2":
        return PhosphorIcons.link_break;
      case "3":
        return PhosphorIcons.identification_badge;
    }
    return PhosphorIcons.cube;
  }
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          getName(widget.state) ,
          textAlign: TextAlign.right,
          style: TextStyle(
            color:  getColor(widget.state),
            fontSize: 12,
            fontFamily: 'santo',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.50,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: ShapeDecoration(
            color: getColor(widget.state),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.50, color: Color(0xFFD0D5DD)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
          child: Icon(
            getIcon(widget.state),
            size: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
