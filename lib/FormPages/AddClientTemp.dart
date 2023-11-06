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
import 'package:om_united/Model/MachineCategories.dart';
import 'package:om_united/Pages/Inventory.dart';
import 'package:om_united/utilis/Utilis.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/CustomAlertDialog.dart';
import '../Fragments/MiniFragmnet.dart';
import 'package:http/http.dart' as http;

class AddClientTemp extends StatefulWidget {
  const AddClientTemp({Key? key}) : super(key: key);

  @override
  State<AddClientTemp> createState() => _AddClientTempState();
}

class _AddClientTempState extends State<AddClientTemp> {
  @override
  Widget build(BuildContext context) {
    return const MiniFragmnet(
      content: AddClientForm(),
    );
  }
}

class AddClientForm extends StatefulWidget {
  const AddClientForm({Key? key}) : super(key: key);

  @override
  State<AddClientForm> createState() => _AddClientFormState();
}

class _AddClientFormState extends State<AddClientForm> {
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _nationalIDTextController = TextEditingController();
  TextEditingController _guardPhoneTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> Submit() async {
      if (_nameTextController.text != "") {
        context.loaderOverlay.show();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var request = http.MultipartRequest(
          "POST",
          Uri.parse("${URL_PROVIDER()}/Clients.php"),
        );

        request.fields.addAll({
          "name": _nameTextController.text,
          "phone": _phoneTextController.text,
          "national_id": _nationalIDTextController.text,
          "guard_phone": _guardPhoneTextController.text,
          "address": _addressTextController.text,
        });

        var response = await request.send();

        if (response.statusCode == 200) {
          context.loaderOverlay.hide();
          var responseOnce = await response.stream.bytesToString();
          if (responseOnce.contains("Duplicate entry")) {
            Fluttertoast.showToast(
                msg: "العميل موجود بالفعل",
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
              Navigator.pop(context);
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
      Container(
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
              'بيانات العميل',
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
                      noIconedTextField('اسم المستأجر', _nameTextController,
                          onTextChange: (value) {}, height: 40),
                      const SizedBox(
                        height: 10,
                      ),
                      noIconedTextField('رقم الهاتف', _phoneTextController,
                          onTextChange: (value) {}, height: 40),
                      const SizedBox(
                        height: 10,
                      ),
                      noIconedTextField('رقم الهوية', _nationalIDTextController,
                          onTextChange: (value) {}, height: 40),
                      const SizedBox(
                        height: 10,
                      ),
                      noIconedTextField('رقم الحارس', _guardPhoneTextController,
                          onTextChange: (value) {}, height: 40),
                      const SizedBox(
                        height: 10,
                      ),
                      noIconedTextField('رابط العنوان', _addressTextController,
                          onTextChange: (value) {}, height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
    return LoaderOverlay(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SubHeader(
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
                child: Column(
                  children: [
                    Column(
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

  const SubHeader({Key? key, required this.Submit}) : super(key: key);

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
              const Text(
                'اضافة عميل',
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
