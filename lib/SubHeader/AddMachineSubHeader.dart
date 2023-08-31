import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Components/Widgets.dart';

class AddPageSubHeader extends StatefulWidget {
  final bool isAddvisible;
  final Function method;

  const AddPageSubHeader(
      {Key? key, required this.isAddvisible, required this.method})
      : super(key: key);

  @override
  State<AddPageSubHeader> createState() => _AddPageSubHeader();
}

class _AddPageSubHeader extends State<AddPageSubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15,right: 15,top: 50,bottom: 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'اضافة منتج',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
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
            child: subHeaderNoIconButton(
                'اضافة', widget.isAddvisible ?  () {widget.method();} : null),
          ),
        ],
      ),
    );
  }
}
