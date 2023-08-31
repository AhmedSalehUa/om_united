import 'package:flutter/material.dart';
import 'package:om_united/Model/MaintainceComment.dart';

class CommentItems extends StatefulWidget {
  final MaintainceComment comment;

  const CommentItems({Key? key, required this.comment}) : super(key: key);

  @override
  State<CommentItems> createState() => _CommentItemsState();
}

class _CommentItemsState extends State<CommentItems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end ,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.comment.Date,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF98A1B2),
                    fontSize: 11,
                    fontFamily: 'sonto',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.50,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.comment.UserName,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF1A1A24),
                    fontSize: 14,
                    fontFamily: 'sonto',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.10,
                  ),
                ),
                CircleAvatar(
                  child:
                      Image.network(widget.comment.img!),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.comment.comment,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 16,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.50,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 1,
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ],
    );
  }
}
