import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class SearchResultSubHeader extends StatefulWidget {
  final String searchText;

  const SearchResultSubHeader({Key? key, required this.searchText})
      : super(key: key);

  @override
  State<SearchResultSubHeader> createState() => _SearchResultSubHeader();
}

class _SearchResultSubHeader extends State<SearchResultSubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15,right: 15,top: 50,bottom: 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Text(
                'نتائج البحث عن “${widget.searchText}”',
                textAlign: TextAlign.right,
                style:const TextStyle(
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

        ],
      ),
    );
  }
}
