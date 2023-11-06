import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/FormPages/AddMachine.dart';

class InventorySubHeader extends StatefulWidget {
  final int totalItems;final int totalValue;

  final bool isAddvisible;

  const InventorySubHeader(
      {Key? key, required this.totalItems, required this.totalValue, required this.isAddvisible})
      : super(key: key);

  @override
  State<InventorySubHeader> createState() => _InventorySubHeader();
}

class _InventorySubHeader extends State<InventorySubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
      child: Stack(
        children: [
          Column(
            children: [

              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'المخزون',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ('العدد (${widget.totalItems})'),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF98A1B2),
                    fontSize: 14,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ('القيمة (${widget.totalValue})'),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF98A1B2),
                    fontSize: 14,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          widget.isAddvisible
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  child: subHeaderButton(
                     kIsWeb? 'اضافة منتج':'', PhosphorIcons.plus_circle, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddMachine()));
                  }),
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
