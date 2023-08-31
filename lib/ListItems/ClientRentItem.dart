 import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../Model/Rent.dart';
import '../utilis/Utilis.dart';

class ClientRentItem extends StatefulWidget {
  final Rent rent;

  const ClientRentItem({Key? key, required this.rent}) : super(key: key);

  @override
  State<ClientRentItem> createState() => _ClientRentItemState();
}

class _ClientRentItemState extends State<ClientRentItem> {
  @override
  Widget build(BuildContext context) {

    List<Widget> content =[ Container(
    width: 65,
    height: 80,
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 0.50, color: Color(0x14344054)),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: GestureDetector(
      onTap: () {LAUNCH_URL(widget.rent.imageUrl);},
      child: CachedNetworkImage(
        imageUrl: widget.rent.imageUrl,
        fit: BoxFit.fill,
      ),

    ),
  ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.rent.name,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Color(0xFF1A1A24),
            fontSize: 14,
            fontFamily: 'sonto',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.10,
          ),
        ),
        Text(
          widget.rent.date,
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
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                onPressed: () {
                  print(widget.rent.location);
                  LAUNCH_URL(widget.rent.location);

                },
                icon: const Icon(
                  PhosphorIcons.map_pin,
                  size: 18,
                  color: Color(0xFF2F68EE),
                ),
                label: const Text(
                  'رابط العنوان',
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                onPressed: () => {LAUNCH_URL("tel:"+widget.rent.phone) },
                icon: const Icon(
                  PhosphorIcons.phone,
                  size: 18,
                  color: Color(0xFF2F68EE),
                ),
                label: Text(
                  widget.rent.phone,
                  style: const TextStyle(
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'الهوية : ${widget.rent.nationalId}',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF475467),
              fontSize: 12,
              fontFamily: 'santo',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.50,
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'الحارس  : ${widget.rent.guardPhone}',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF475467),
              fontSize: 12,
              fontFamily: 'santo',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.50,
            ),
          ),
        ),
      ],
    )];
    return Container(
      height:  kIsWeb?180:260 ,
      padding: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0x14344054)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child:kIsWeb? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: content,
      ):Column(children: content,verticalDirection: VerticalDirection.up),
    );
  }
}
