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
import 'package:om_united/Pages/InventoryPage.dart';
import 'package:om_united/utilis/Utilis.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/CustomAlertDialog.dart';
import '../Components/Header.dart';
import 'MainFragmnet.dart';
import 'MiniFragmnet.dart';
import 'package:http/http.dart' as http;

class AddMachineCategory extends StatefulWidget {
  const AddMachineCategory({Key? key}) : super(key: key);

  @override
  State<AddMachineCategory> createState() => _AddMachineCategoryState();
}

class _AddMachineCategoryState extends State<AddMachineCategory> {
  @override
  Widget build(BuildContext context) {
    return const MiniFragmnet(
      content: AddMachineForm(),
    );
  }
}

class AddMachineForm extends StatefulWidget {
  const AddMachineForm({Key? key}) : super(key: key);

  @override
  State<AddMachineForm> createState() => _AddMachineFormState();
}

class _AddMachineFormState extends State<AddMachineForm> {
  late Future<List<MachineCategories>> _futureItems;

  String? selectedValue;
  String mode = "add";

  TextEditingController _idTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _weightFromTextController = TextEditingController();
  TextEditingController _weightToTextController = TextEditingController();

  late Response response;
  late String progress = "";

  Future<List<MachineCategories>> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse("${URL_PROVIDER()}/MachinesCategories.php"), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      final jsonData = jsonDecode(response.body);
      final List<MachineCategories> items = [];

      for (var itemJson in jsonData) {

        final item = MachineCategories.fromJson(itemJson);

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
  }

  @override
  Widget build(BuildContext context) {
    void clear() {
      _idTextController.text = "";
      _nameTextController.text = "";
      _weightFromTextController.text = "";
      _weightToTextController.text = "";
      setState(() {
        mode = "add";
      });
    }

    Future<void> Submit(String method) async {
      if (_nameTextController.text != "" &&
          _weightToTextController.text != "" &&
          _weightFromTextController.text != "") {
        context.loaderOverlay.show();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var request = http.MultipartRequest(
          "POST",
          Uri.parse("${URL_PROVIDER()}/MachinesCategories.php"),
        );

        if (method == "add") {
          request.fields.addAll({
            "name": _nameTextController.text,
            "weight_from": _weightFromTextController.text,
            "weight_to": _weightToTextController.text,
          });
        } else if (method == "edit") {
          request.fields.addAll({
            "id": _idTextController.text,
            "name": _nameTextController.text,
            "weight_from": _weightFromTextController.text,
            "weight_to": _weightToTextController.text,
          });
        } else {
          request.fields.addAll({
            "id": _idTextController.text,
            "delete": "true",
            "name": _nameTextController.text,
            "weight_from": _weightFromTextController.text,
            "weight_to": _weightToTextController.text,
          });
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          context.loaderOverlay.hide();
          var responseOnce = await response.stream.bytesToString();
          if (responseOnce.contains("Duplicate entry")) {
            Fluttertoast.showToast(
                msg: "الفئة موجودة بالفعل",
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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>MainFragmnet(
                          subHeader: SizedBox(),
                          content: SizedBox(),
                          isMainWidget: false,
                          selectedIndex: 1)));
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
      }else{
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
            Directionality(textDirection: TextDirection.rtl,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                child: FutureBuilder<List<MachineCategories>>(
                  future: _futureItems,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final items = snapshot.data!;
                      return GridView.builder(
                        physics: ScrollPhysics(),
                        itemCount: items.length,
                        cacheExtent: 9999,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: kIsWeb ? 200 : 170,
                          crossAxisCount: kIsWeb
                              ? MediaQuery.of(context).size.width ~/ 280
                              : 2,
                          crossAxisSpacing: kIsWeb ? 90 : 20,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                mode = "edit";
                              });
                              _idTextController.text = item.id.toString();
                              _nameTextController.text = item.name;
                              _weightFromTextController.text = item.weight_from;
                              _weightToTextController.text = item.weight_to;
                            },
                            child: Container(
                              decoration: ShapeDecoration(
                                color: Color.fromRGBO(168, 213, 252, 1.0),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.50, color: Color(0x14344054)),
                                  borderRadius: BorderRadius.circular(21),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        mode = "edit";
                                      });
                                      _idTextController.text = item.id.toString();
                                      _nameTextController.text = item.name;
                                      _weightFromTextController.text =
                                          item.weight_from;
                                      _weightToTextController.text =
                                          item.weight_to;
                                    },
                                    elevation: 2.0,
                                    fillColor:
                                        const Color.fromRGBO(205, 230, 244, 1),
                                    padding: const EdgeInsets.all(10),
                                    shape: const CircleBorder(),
                                    child: Text(
                                      item.name,
                                      style: TextStyle(fontSize: 28),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.weight_from,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "الوزن من",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.weight_to,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "الوزن الي",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            const Text(
              'بيانات الفئة',
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
                      noIconedTextField('الاسم', _nameTextController,
                          onTextChange: (value) {}),
                      const SizedBox(
                        height: 16,
                      ),
                      noIconedTextField('الوزن من', _weightFromTextController,
                          onTextChange: (value) {}),
                      const SizedBox(
                        height: 10,
                      ),
                      noIconedTextField('الوزن الي', _weightToTextController,
                          onTextChange: (value) {}),
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
          kIsWeb
              ? const Header(
                  isMain: false,
                )
              : SizedBox(),
          SubHeader(
            mode: mode,
            Clear: clear,
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
  final String mode;

  final Function Clear;
  final Function(String meth) Submit;

  const SubHeader(
      {Key? key, required this.mode, required this.Submit, required this.Clear})
      : super(key: key);

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
                'اضافة فئة',
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
          Visibility(
            visible: widget.mode == "add",
            child: Positioned(
              bottom: 0,
              left: 0,
              child: subHeaderNoIconButton('اضافة', () {
                widget.Submit("add");
              }),
            ),
          ),
          Visibility(
            visible: widget.mode != "add",
            child: Positioned(
              bottom: 0,
              left: 0,
              child: subHeaderButton('تعديل', PhosphorIcons.pencil_simple, () {
                widget.Submit("edit");
              }),
            ),
          ),
          Visibility(
            visible: widget.mode != "add",
            child: Positioned(
              bottom: 0,
              left: 100,
              child: subHeaderButton(
                'حذف',
                PhosphorIcons.trash,
                () {
                  showDialog(
                    barrierColor: Colors.black26,
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        title: "هل انت متأكد من رغبتك في حذف الفئة",
                        description: "لن تستطيع اعادته مرة أخرى",
                        onConfirm: () {
                          widget.Submit("delete");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InventoryPage()));
                        },
                      );
                    },
                  );
                },
                color: const Color.fromRGBO(249, 213, 218, 1),
                shadow: const Color(0x4CF9D5DA),
              ),
            ),
          ),
          Visibility(
            visible: widget.mode != "add",
            child: Positioned(
              bottom: 0,
              left: 200,
              child: subHeaderButton(
                'الغاء',
                PhosphorIcons.door,
                () {
                  widget.Clear();
                },
                color: const Color.fromRGBO(249, 213, 218, 1),
                shadow: const Color(0x4CF9D5DA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
