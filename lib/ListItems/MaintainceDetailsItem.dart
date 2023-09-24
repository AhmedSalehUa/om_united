import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/ListItems/CommentItems.dart';
import 'package:om_united/ListItems/MachineItem.dart';
import 'package:om_united/Model/MaintainceAttachments.dart';
import 'package:om_united/Model/MaintainceComment.dart';
import 'package:om_united/Model/Machine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../Model/Maintaince.dart';
import '../utilis/Utilis.dart';

class MaintainceDetailsItem extends StatefulWidget {
  final Maintaince maintaince;
  final Machine machine;

  const MaintainceDetailsItem(
      {Key? key, required this.maintaince, required this.machine})
      : super(key: key);

  @override
  State<MaintainceDetailsItem> createState() => _MaintainceDetailsItemState();
}

class _MaintainceDetailsItemState extends State<MaintainceDetailsItem> {
  TextEditingController _messageController = TextEditingController();

  void fetchData(id) async {
    try {
      final response = await http
          .get(Uri.parse("${URL_PROVIDER()}/Comments.php?id=$id"), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      final jsonData = jsonDecode(response.body);
      final List<MaintainceComment> maintainceComments = [];

      for (var itemJson in jsonData['Maintainces']) {
        // print(itemJson);
        final item = MaintainceComment.fromJson(itemJson);
        maintainceComments.add(item);
      }

      setState(() {
        widget.maintaince.comments = maintainceComments;
        commentsList = widget.maintaince.comments != null
            ? widget.maintaince.comments!
            : [];
      });
    } catch (e) {
      print("excep ${e}");
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    commentsList =
        widget.maintaince.comments != null ? widget.maintaince.comments! : [];
  }

  List<MaintainceComment> commentsList = [];

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MaintainceAttachments> attachmens =
        widget.maintaince.attachments != null
            ? widget.maintaince.attachments!
            : [];
    List<Widget> comments =
        commentsList.map((item) => CommentItems(comment: item)).toList();
    List<Widget> attachments = attachmens
        .map((e) => Container(
              width: 64,
              height: 64,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2, color: Color(0x14344054)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  _launchUrl(Uri.parse(e.photo));
                },
                child: CachedNetworkImage(
                  imageUrl: e.photo,
                  fit: BoxFit.fill,
                ),
              ),
            ))
        .toList();
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0x14344054)),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(PhosphorIcons.x),
                      ),
                      const Text(
                        'تفاصيل الصيانة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF1A1A24),
                          fontSize: 22,
                          fontFamily: 'santo',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Text(
                    widget.maintaince.date,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF98A1B2),
                      fontSize: 11,
                      fontFamily: 'santo',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.50,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusItem(state: widget.machine.status),
                      Row(
                        children: [
                          SizedBox(
                            width: kIsWeb
                                ? MediaQuery.of(context).size.width * 0.8
                                : MediaQuery.of(context).size.width * .5,
                            child: Text(
                              widget.machine.name,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFF475467),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12,
                                fontFamily: 'santo',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 2, color: Color(0x14344054)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.machine.imageUrl != null
                                  ? widget.machine.imageUrl!
                                  : "https://static.vecteezy.com/system/resources/thumbnails/004/607/806/small/man-face-emotive-icon-smiling-bearded-male-character-in-yellow-flat-illustration-isolated-on-white-happy-human-psychological-portrait-positive-emotions-user-avatar-for-app-web-design-vector.jpg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.maintaince.UserName,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF1A1A24),
                          fontSize: 14,
                          fontFamily: 'sonto',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.10,
                        ),
                      ),
                      CircleAvatar(
                        child: Image.network(widget.maintaince.img!),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.maintaince.notes,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Color(0xFF475467),
                      fontSize: 12,
                      fontFamily: 'sonto',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.50,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: attachments,
                  )
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              IconedActionTextField("اكتب تعليق", PhosphorIcons.paper_plane_tilt,
                  _messageController, () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                var request = http.MultipartRequest(
                  "POST",
                  Uri.parse("${URL_PROVIDER()}/Comments.php"),
                );
                request.fields.addAll({
                  "maintance_id": widget.maintaince.id.toString(),
                  "user_id": prefs.getInt("id").toString(),
                  "comment": _messageController.text,
                });
                var response = await request.send();

                if (response.statusCode == 200) {
                  fetchData(widget.maintaince.id.toString());
                  _messageController.value = TextEditingValue(text: "");
                } else {
                  Fluttertoast.showToast(
                    msg: "NetworkError",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              }),
              const SizedBox(
                height: 18,
              ),
              Column(
                children: comments,
              )
            ],
          ),
        ),
      ),
    );
  }
}
