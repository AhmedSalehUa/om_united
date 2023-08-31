import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPageSubHeader extends StatefulWidget {
  final String name  ;
  const MainPageSubHeader({Key? key,required this.name}) : super(key: key);

  @override
  State<MainPageSubHeader> createState() => _MainPageSubHeaderState();
}

class _MainPageSubHeaderState extends State<MainPageSubHeader> {

  @override
  Widget build(BuildContext context)   {
    return   Container(
      padding: const EdgeInsets.only(left: 15,right: 15,top: 50,bottom: 15),
      child:  Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'صباح الخير',
              textAlign: TextAlign.right,
              style: TextStyle(
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
              widget.name,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontFamily: 'santo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
