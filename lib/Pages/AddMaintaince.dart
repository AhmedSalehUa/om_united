
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/Header.dart';
import '../Components/MultipleImageDragged.dart';
import '../Model/Machine.dart';
import '../utilis/Utilis.dart';
import 'HomePage.dart';
import 'MiniFragmnet.dart';

class AddMaintaince extends StatefulWidget {
  final Machine item;

  const AddMaintaince({Key? key, required this.item}) : super(key: key);

  @override
  State<AddMaintaince> createState() => _AddMaintainceState();
}

class _AddMaintainceState extends State<AddMaintaince> {
  @override
  Widget build(BuildContext context) {
    return MiniFragmnet(
      content: AddMaintainceForm(
        item: widget.item,
      ),
    );
  }
}

class AddMaintainceForm extends StatefulWidget {
  final Machine item;

  const AddMaintainceForm({Key? key, required this.item}) : super(key: key);

  @override
  State<AddMaintainceForm> createState() => _AddMaintainceFormState();
}

class _AddMaintainceFormState extends State<AddMaintainceForm> {
  bool isActive = false;

  List<PlatformFile>? _mainetaincePhotos;

  TextEditingController _nameTextController = TextEditingController();

  @override
  void initState() {
    setState(() {
      isActive = false;
    });

    super.initState();
  }

  void setMaintainceImages(List<PlatformFile> imgs) {
    _mainetaincePhotos = imgs;
  }

  late Response response;
  late String progress = "";

  @override
  Widget build(BuildContext context) {
    Future<void> Submit() async {
      context.loaderOverlay.show();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${URL_PROVIDER()}/MaintancesCrud.php"),
      );
      if (kIsWeb) {
        if (_mainetaincePhotos != null) {
          for (var i = 0; i < _mainetaincePhotos!.length; i++) {
            request.files.add(
              http.MultipartFile.fromBytes(
                "file$i",
                _mainetaincePhotos![i].bytes!,
                filename: _mainetaincePhotos![i].name,
              ),
            );
          }
        }
      } else {
        if (_mainetaincePhotos != null) {
          for (var i = 0; i < _mainetaincePhotos!.length; i++) {
            request.files.add(
              await http.MultipartFile.fromPath(
                "file$i",
                _mainetaincePhotos![i].path!,
                filename: basename(_mainetaincePhotos![i].path!),
              ),
            );
          }
        }
      }
      request.fields.addAll({
        "imageNum" :request.files.length.toString(),
        "machine_id": widget.item.id.toString(),
        "user_id": prefs.getInt("id").toString(),
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "comments": _nameTextController.text  ,
      });
      var response = await request.send();
      if (response.statusCode == 200) {

        context.loaderOverlay.hide();

        var res = json.decode(await response.stream.bytesToString());

        if (res["error"]) {
          Fluttertoast.showToast(
              msg: res["message"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP_RIGHT,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
          Fluttertoast.showToast(
              msg: res["message"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP_RIGHT,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        context.loaderOverlay.hide();
        Fluttertoast.showToast(
          msg: "NetworkError",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }

    return LoaderOverlay(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        kIsWeb ?  const Header(
            isMain: false,
          ):SizedBox(),
          SubHeader(
            isActive: isActive,
            Submit: Submit,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(20),
              decoration: const ShapeDecoration(
                color: Color.fromRGBO(249, 250, 251, 1),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 0.50, color: Color.fromRGBO(52, 64, 84, 1)),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.50, color: Color(0x14344054)),
                      borderRadius: BorderRadius.circular(21),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'البيانات الأساسية',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF1A1A24),
                            fontSize: 16,
                            fontFamily: 'santo',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.15,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        MultipleImageDragged(
                          text: 'صورة أو فيديو',
                          url: [],
                          photos: setMaintainceImages,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: 368,
                          child: noIconedTextArea(
                            'تعليقك (اختياري)',
                            _nameTextController,
                            onTextChange: (value) {
                              if (_nameTextController.text != "") {
                                setState(() {
                                  isActive = true;
                                });
                              } else {
                                setState(() {
                                  isActive = false;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SubHeader extends StatefulWidget {
  final bool isActive;

  final Function Submit;

  const SubHeader({Key? key, required this.isActive, required this.Submit})
      : super(key: key);

  @override
  State<SubHeader> createState() => _SubHeaderState();
}

class _SubHeaderState extends State<SubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(

      padding:kIsWeb ? const EdgeInsets.all(15): const EdgeInsets.fromLTRB(15, 50, 15, 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'صيانة المنتج',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize:  kIsWeb ? 32 : 16,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(
                  PhosphorIcons.arrow_right,
                  color: Colors.white,
                  size:  kIsWeb ? 24 : 18,
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
                'حفظ',
                widget.isActive
                    ? () {
                        widget.Submit();
                      }
                    : null),
          ),
        ],
      ),
    );
  }
}
