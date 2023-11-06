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
import 'package:http/http.dart' as http;

import '../Model/ClientsModel.dart';

class AddClient extends StatefulWidget {
  final String id;

  const AddClient({Key? key, required this.id}) : super(key: key);

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  @override
  Widget build(BuildContext context) {
    return AddClientForm(
      id: widget.id,
    );
  }
}

class AddClientForm extends StatefulWidget {
  final String id;

  const AddClientForm({Key? key, required this.id}) : super(key: key);

  @override
  State<AddClientForm> createState() => _AddClientFormState();
}

class _AddClientFormState extends State<AddClientForm> {
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _nationalIDTextController = TextEditingController();
  TextEditingController _guardPhoneTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();

  ClientsModel? item;

  Future<ClientsModel?> fetchData(String id) async {
    try {
      final response = await http
          .get(Uri.parse("${URL_PROVIDER()}/Clients.php?id=" + id), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      final jsonData = jsonDecode(response.body);
      ClientsModel? items;

      for (var itemJson in jsonData) {
        items = ClientsModel.fromJson(itemJson);
      }
      return items;
    } catch (e) {
      print("excep ${e}");
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != "") {
      fetchData(widget.id).then((value) {
        item = value;
        _nameTextController.text = item!.name;
        _phoneTextController.text = item!.phone;
        _nationalIDTextController.text = item!.nationalId;
        _guardPhoneTextController.text = item!.guardPhone;
        _addressTextController.text = item!.location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> Submit() async {
      if (_nameTextController.text != "") {
        context.loaderOverlay.show();
        var request = http.MultipartRequest(
          "POST",
          Uri.parse("${URL_PROVIDER()}/Clients.php"),
        );
        if (widget.id == "") {
          request.fields.addAll({
            "name": _nameTextController.text,
            "phone": _phoneTextController.text,
            "national_id": _nationalIDTextController.text,
            "guard_phone": _guardPhoneTextController.text,
            "address": _addressTextController.text,
          });
        } else {
          request.fields.addAll({
            "id": widget.id,
            "name": _nameTextController.text,
            "phone": _phoneTextController.text,
            "national_id": _nationalIDTextController.text,
            "guard_phone": _guardPhoneTextController.text,
            "address": _addressTextController.text,
          });
        }


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
                      const SizedBox(
                        height: 30,
                      ),
                      widget.id == ""
                          ? Container(
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(6, 138, 200, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: InkWell(
                                highlightColor: Colors.grey[200],
                                onTap: () {
                                  Submit();
                                },
                                child: Center(
                                  child: Text(
                                    "اضافة عميل",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'santo',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(6, 138, 200, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: InkWell(
                                highlightColor: Colors.grey[200],
                                onTap: () {
                                  Submit();
                                },
                                child: Center(
                                  child: Text(
                                    "تعديل العميل",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'santo',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                ),
                              ),
                            )
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
