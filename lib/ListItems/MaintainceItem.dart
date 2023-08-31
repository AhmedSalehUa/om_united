import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/ListItems/MaintainceDetailsItem.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:om_united/Model/Maintaince.dart';

class MaintainceItem extends StatefulWidget {
  final Maintaince maintaince;
  final Machine machine;

  const MaintainceItem(
      {Key? key, required this.maintaince, required this.machine})
      : super(key: key);

  @override
  State<MaintainceItem> createState() => _MaintainceItemState();
}

class _MaintainceItemState extends State<MaintainceItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0x14344054)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextButton.icon(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                elevation: 2,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0x14344054)),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(21),
                      topLeft: Radius.circular(21)),
                ),
                builder: (BuildContext context) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  final desiredHeight = screenHeight *
                      0.75; // set the height to 90% of the screen height
                  return Container(
                    height: desiredHeight,
                    child: MaintainceDetailsItem(
                      maintaince: widget.maintaince,
                      machine: widget.machine,
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              PhosphorIcons.chat_dots,
              size: 18,
              color: Color(0xFF2F68EE),
            ),
            label: const Text(
              'عرض التفاصيل',
              style: TextStyle(
                color: Color(0xFF2F68EE),
                fontSize: 14,
                fontFamily: 'santo',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.10,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.white,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.maintaince.date,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF98A1B2),
                fontSize: 11,
                fontFamily: 'sonto',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.50,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    widget.maintaince.UserName,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF1A1A24),
                      fontSize: 14,
                      fontFamily: 'sonto',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
                CircleAvatar(backgroundColor: Colors.white,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Image.network(
                        widget.maintaince.img != ""
                            ? widget.maintaince.img!
                            : "https://static.vecteezy.com/system/resources/thumbnails/004/607/806/small/man-face-emotive-icon-smiling-bearded-male-character-in-yellow-flat-illustration-isolated-on-white-happy-human-psychological-portrait-positive-emotions-user-avatar-for-app-web-design-vector.jpg",
                      ),),
                )
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
