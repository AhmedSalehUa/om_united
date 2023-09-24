import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:om_united/Model/ClientsModel.dart';
import 'package:om_united/utilis/Utilis.dart';
import 'package:http/http.dart' as http;

import '../Components/CustomAlertDialog.dart';
import '../Components/Widgets.dart';
import 'ClientForm.dart';

class ClientDropDownCRUD extends StatefulWidget {
  final Function onChange;
  final Function onSave;
  final String initialValue;

  const ClientDropDownCRUD(
      {Key? key,
      required this.onChange,
      required this.onSave,
      required this.initialValue})
      : super(key: key);

  @override
  State<ClientDropDownCRUD> createState() => _ClientDropDownCRUDState();
}

class _ClientDropDownCRUDState extends State<ClientDropDownCRUD> {
  @override
  Widget build(BuildContext context) {
    return DropDown(
        onChange: widget.onChange,
        onSave: widget.onSave,
        initialValue: widget.initialValue);
  }
}

class DropDown extends StatefulWidget {
  final Function onChange;
  final Function onSave;
  final String initialValue;

  const DropDown(
      {Key? key,
      required this.onChange,
      required this.onSave,
      required this.initialValue})
      : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  late Future<List<ClientsModel>> _futureItems;

  String? selectedValue;

  Future<List<ClientsModel>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse("${URL_PROVIDER()}/Clients.php"), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      final jsonData = jsonDecode(response.body);
      final List<ClientsModel> items = [];

      for (var itemJson in jsonData) {
        final item = ClientsModel.fromJson(itemJson);

        items.add(item);
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
    _futureItems = fetchData();
    setState(() {
      if (widget.initialValue != "") selectedValue = widget.initialValue!;
    });
  }

  Future<void> Delete(String id) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${URL_PROVIDER()}/Clients.php"),
    );
    request.fields.addAll({
      "id": id,
      "delete": "true",
    });

    var response = await request.send();
    // print("object");
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var resString = await response.stream.bytesToString();

      if (resString.contains("foreign key")) {
        Fluttertoast.showToast(
            msg: "العميل مرتبط بايجار",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP_RIGHT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        var res = json.decode(resString);
        // print(res);
        if (res["error"]) {
          Fluttertoast.showToast(
              msg: res["message"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP_RIGHT,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          setState(() {
            selectedValue = null;
            _futureItems = fetchData();
          });
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
      Fluttertoast.showToast(
        msg: "NetworkError",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          subHeaderButton('', PhosphorIcons.plus_circle, () {
            showModalBottomSheet<void>(
              context: context,
              elevation: 2,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                side: BorderSide(width: 0.50, color: Color(0x14344054)),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(21),
                    topLeft: Radius.circular(21)),
              ),
              builder: (BuildContext context) {
                final screenHeight = MediaQuery.of(context).size.height;
                final desiredHeight = screenHeight *
                    0.9; // set the height to 90% of the screen height
                return Container(
                  height: desiredHeight,
                  child: AddClient(id: "",),
                );
              },
            ).then((value) => setState(() {
                  _futureItems = fetchData();
                }));
          }),
          SizedBox(
            width: 10,
          ),
          selectedValue != null
              ? subHeaderButton('', PhosphorIcons.pencil_simple, () {
                  showModalBottomSheet<void>(
                    context: context,
                    elevation: 2,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 0.50, color: Color(0x14344054)),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(21),
                          topLeft: Radius.circular(21)),
                    ),
                    builder: (BuildContext context) {
                      final screenHeight = MediaQuery.of(context).size.height;
                      final desiredHeight = screenHeight *
                          0.9; // set the height to 90% of the screen height
                      return Container(
                        height: desiredHeight,
                        child: AddClient(id :selectedValue!),
                      );
                    },
                  ).then((value) => setState(() {
                        _futureItems = fetchData();
                      }));
                })
              : SizedBox(),
          SizedBox(
            width: 10,
          ),
          selectedValue != null
              ? subHeaderButton(
                  '',
                  PhosphorIcons.trash,
                  () {
                    showDialog(
                      barrierColor: Colors.black26,
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          title: "هل انت متأكد من رغبتك في حذف العميل",
                          description: "لن تستطيع اعادته مرة أخرى",
                          onConfirm: () {
                            Delete(selectedValue!);
                          },
                        );
                      },
                    );
                  },
                  color: const Color.fromRGBO(249, 213, 218, 1),
                  shadow: const Color(0x4CF9D5DA),
                )
              : SizedBox(),
          FutureBuilder<List<ClientsModel>>(
            future: _futureItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data!;
                return SizedBox(
                  width: kIsWeb ? 300 : 200,
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Color.fromRGBO(208, 213, 221, 1),
                        ),
                        color: const Color.fromRGBO(249, 250, 251, 1),
                      ),
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    hint: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: const Text(
                        'اختر العميل',
                        style: TextStyle(
                          color: Color(0xFF475467),
                          fontSize: 12,
                          fontFamily: 'santo',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    items: items.map((item) {
                      return DropdownMenuItem(
                        value: item.id.toString(),
                        child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(
                              item.name,
                              style: TextStyle(fontSize: 14),
                            )),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        selectedValue = newVal.toString();
                      });
                      widget.onChange(newVal);
                    },
                    value: selectedValue,
                    validator: (value) {
                      if (value == null) {
                        return 'اختر';
                      }
                      return null;
                    },
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        PhosphorIcons.caret_down,
                        color: selectedValue?.isEmpty ?? true
                            ? const Color.fromRGBO(152, 162, 179, 1)
                            : const Color.fromRGBO(249, 250, 251, 1),
                      ),
                      iconSize: 18,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

class miniClient extends StatefulWidget {
  final ClientsModel client;

  const miniClient({Key? key, required this.client}) : super(key: key);

  @override
  State<miniClient> createState() => _miniClientState();
}

class _miniClientState extends State<miniClient> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.client.name,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "الي",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  widget.client.nationalId,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "من",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        RawMaterialButton(
          onPressed: () {},
          elevation: 2.0,
          fillColor: const Color.fromRGBO(205, 230, 244, 1),
          shape: const CircleBorder(),
          child: Text(
            widget.client.name,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
