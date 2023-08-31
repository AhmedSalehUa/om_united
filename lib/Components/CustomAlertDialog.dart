import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title, description;

  final Function onConfirm;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: 475,
        height: kIsWeb? 236:280,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Text(
                widget.title,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF1A1A24),
                  fontSize:  kIsWeb?22:18,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Text(
                widget.description,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 14,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Divider(
              height: 1,
            ),
            Container(
              decoration: const ShapeDecoration(
                color: Color.fromRGBO(238, 47, 47, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: InkWell(
                highlightColor: Colors.grey[200],
                onTap: () {
                  widget.onConfirm();
                  Navigator.pop(context);
                },
                child: const Center(
                  child: Text(
                    "حذف نهائياً",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            SizedBox(
              height: 50,
              child: InkWell(
                highlightColor: Colors.grey[200],
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                  child: Text(
                    "إلغاء العملية",
                    style: TextStyle(
                      color: Color(0xFF068AC8),
                      fontSize: 14,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
