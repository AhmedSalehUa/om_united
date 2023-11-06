import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:om_united/Components/DatePicker.dart';
import 'package:om_united/Components/ImageDragged.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/ListItems/MachineCategoryItem.dart';
import 'package:om_united/FormPages/AddMachineCategory.dart';
import 'package:om_united/Model/AssetsCategory.dart';
import 'package:om_united/Pages/Inventory.dart';
import 'package:om_united/utilis/Utilis.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/MultipleImageDragged.dart';
import '../Fragments/MobileFragment.dart';
import '../Fragments/WebFragment.dart';
import '../ListItems/ClientDropDown.dart';
import '../Model/MachineCategories.dart';
import 'AddClientTemp.dart';
import '../Fragments/MiniFragmnet.dart';
import 'package:http/http.dart' as http;

class AddAsset extends StatefulWidget {
  final AssetsCategory category;
  const AddAsset({Key? key,required this.category}) : super(key: key);

  @override
  State<AddAsset> createState() => _AddAssetState();
}

class _AddAssetState extends State<AddAsset> {
  @override
  Widget build(BuildContext context) {
    return   MiniFragmnet(
      content: AddAssetForm(category: widget.category,),
    );
  }
}

class AddAssetForm extends StatefulWidget {
  final AssetsCategory category;
  const AddAssetForm({Key? key,required this.category} ) : super(key: key);

  @override
  State<AddAssetForm> createState() => _AddAssetFormState();
}

class _AddAssetFormState extends State<AddAssetForm> {
  String? forRent;

  PlatformFile? _categoryPhotos;

  TextEditingController _nameTextController = TextEditingController();

  TextEditingController _valueTextController = TextEditingController();

  TextEditingController _codeTextController = TextEditingController();

  void setCategoryImage(PlatformFile categoryPhotos) {
    setState(() {
      _categoryPhotos = categoryPhotos;
    });
  }

  late Response response;
  late String progress = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> Submit() async {
      if (_nameTextController.text != "") {
        context.loaderOverlay.show();

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var request = http.MultipartRequest(
          "POST",
          Uri.parse("${URL_PROVIDER()}/Assets.php"),
        );
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              "file",
              _categoryPhotos!.bytes!,
              filename: _categoryPhotos!.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              "file",
              _categoryPhotos!.path!,
              filename: basename(_categoryPhotos!.path!),
            ),
          );
        }

        request.fields.addAll({
          "category_id": widget.category.id.toString(),
          "name": _nameTextController.text,
          "code": _codeTextController.text,
          "value": _valueTextController.text,
        });

        var response = await request.send();

        if (response.statusCode == 200) {
          context.loaderOverlay.hide();
          var responseOnce = await response.stream.bytesToString(); 
          if (responseOnce.contains("Duplicate entry")) {
            Fluttertoast.showToast(
                msg: "الاصل موجود بالفعل",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP_RIGHT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            var res = json.decode(responseOnce);
            if (res["error"]) {
              Fluttertoast.showToast(
                  msg: res["message"],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP_RIGHT,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {

              Navigator.pop(context,"done");
              Fluttertoast.showToast(
                  msg: res["message"],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP_RIGHT,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        } else {
          context.loaderOverlay.hide();

          Fluttertoast.showToast(
            msg: "NetworkError",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "بيانات فارغة",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }

    List<Widget> content = [
      Expanded(
        flex: kIsWeb ? 3 : 0,
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0x14344054)),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
          padding: const EdgeInsets.all(16),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: ImageDragged(
                              text: "صورة الاصل",
                              url: "",
                              photo: setCategoryImage),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        noIconedTextArea(
                          'اسم الاصل ',
                          _nameTextController,
                          onTextChange: (value) {},
                        ),
                        const SizedBox(
                          height: 16,
                        ), noIconedTextField('الرقم التعريفي', _codeTextController,
                            onTextChange: (value) {}),
                        const SizedBox(
                          height: 16,
                        ), const SizedBox(
                          height: 10,
                        ),
                        splittedTextField('قـيـمـــة الاصـــــــل',
                            _valueTextController, 'ريال',
                            height: 40),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    ];
    return LoaderOverlay(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SubHeader(
            Submit: Submit,category:widget.category
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
                child: Column(
                  children: [
                    kIsWeb
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: content,
                          )
                        : Column(
                            verticalDirection: VerticalDirection.up,
                            children: content,
                          ),
                  ],
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
  final Function Submit;

  final AssetsCategory category;
  const SubHeader({Key? key, required this.Submit,required this.category}) : super(key: key);

  @override
  State<SubHeader> createState() => _SubHeaderState();
}

class _SubHeaderState extends State<SubHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kIsWeb
          ? const EdgeInsets.all(15)
          : const EdgeInsets.fromLTRB(15, 50, 15, 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Text(
                'اضافة اصل فى فئة (${widget.category.name})',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: kIsWeb ? 32 : 16,
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
            child: subHeaderNoIconButton('اضافة', () {
              widget.Submit();
            }),
          ),
        ],
      ),
    );
  }
}
