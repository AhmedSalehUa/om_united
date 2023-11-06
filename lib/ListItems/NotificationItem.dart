import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:om_united/ListItems/MachineItem.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/utilis/Utilis.dart';

class NotificationItem extends StatefulWidget {
  final Machine machine;
  bool? visible;

  NotificationItem({Key? key, required this.machine, this.visible})
      : super(key: key);

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: kIsWeb ? const EdgeInsets.all(8) : const EdgeInsets.all(0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
        widget.visible == null
            ? Directionality(
                textDirection: TextDirection.rtl,
                child: getMachineStatus(widget.machine.lastMaintaince!,
                    widget.machine.maintainceEvery,
                    widget.machine.status),
              )
            : SizedBox(),
        Expanded( 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: Text(
                        widget.machine.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF1A1A24),
                          fontSize: 12,
                          fontFamily: 'sonto',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    StatusItem(state: widget.machine.status),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: 65,
                height: 80,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Color(0x14344054)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: CachedNetworkImage(
                    imageUrl: widget.machine.imageUrl!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
