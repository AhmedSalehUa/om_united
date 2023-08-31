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
import 'package:om_united/Pages/InventoryPage.dart';
import 'package:om_united/utilis/Utilis.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/Header.dart';
import 'MiniFragmnet.dart';
import 'package:http/http.dart' as http;

class AddMachine extends StatefulWidget {
  const AddMachine({Key? key}) : super(key: key);

  @override
  State<AddMachine> createState() => _AddMachineState();
}

class _AddMachineState extends State<AddMachine> {
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
  String? selectedValue;
  bool isActive = false;

  PlatformFile? _machinePhotos;
  PlatformFile? _contractPhotos;
   TextEditingController _nameTextController = TextEditingController();
  TextEditingController _codeTextController = TextEditingController();
  TextEditingController _brandTextController = TextEditingController();

   TextEditingController _clientNameTextController = TextEditingController();
  TextEditingController _dateOfContractTextController = TextEditingController();
  TextEditingController _dateRangTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _nationalIdTextController = TextEditingController();
  TextEditingController _guardNumTextController = TextEditingController();
  TextEditingController _maintanceEverTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();

  void setMachineImage(PlatformFile machinePhotos) {
    setState(() {
      _machinePhotos = machinePhotos;
    });
  }

  void setContractImage(PlatformFile contractPhotos) {
    setState(() {
      _contractPhotos = contractPhotos;
    });
  }

  int getStatusID(String value) {
    switch (value) {
      case "inventory":
        return 1;
      case "crashed":
        return 2;
      case "rents":
        return 3;
    }
    return 1;
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
        Uri.parse("${URL_PROVIDER()}/Machines.php"),
      );
      if (kIsWeb) {
        if (selectedValue == "3") {
          request.files.add(
            http.MultipartFile.fromBytes(
              "rent_file",
              _contractPhotos!.bytes!,
              filename: _contractPhotos!.name,
            ),
          );
        }
        request.files.add(
          http.MultipartFile.fromBytes(
            "file",
            _machinePhotos!.bytes!,
            filename: _machinePhotos!.name,
          ),
        );
      } else {
        if (selectedValue == "3") {
          request.files.add(
            await http.MultipartFile.fromPath(
              "rent_file",
              _contractPhotos!.path!,
              filename: basename(_contractPhotos!.path!),
            ),
          );
        }
        request.files.add(
          await http.MultipartFile.fromPath(
            "file",
            _machinePhotos!.path!,
            filename: basename(_machinePhotos!.path!),
          ),
        );
      }

      if (selectedValue == "3") {
        request.fields.addAll({
          "name": _nameTextController.text  ,
          "code": _codeTextController.text  ,
          "brand": _brandTextController.text  ,
          "status": selectedValue == null ? "1" : selectedValue!,
          "rent_user_id": prefs.getInt("id").toString(),
          "rent_name": _clientNameTextController.text,
          "rent_date_from": _dateOfContractTextController.text,
          "rent_date_to": _dateRangTextController.text,
          "rent_phone": _phoneTextController.text,
          "rent_national_id": _nationalIdTextController.text,
          "rent_guard_phone": _guardNumTextController.text,
          "rent_maintance_every": _maintanceEverTextController.text,
          "rent_address": _addressTextController.text,
        });
      } else {
        request.fields.addAll({
          "name": _nameTextController.text  ,
          "code": _codeTextController.text  ,
          "brand": _brandTextController.text  ,
          "status": selectedValue == null ? "1" : selectedValue!,
          "rent_maintance_every": _maintanceEverTextController.text,
        });
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        context.loaderOverlay.hide();
        var responseOnce = await response.stream.bytesToString();
        if(responseOnce.contains("Duplicate entry")) {
          Fluttertoast.showToast(
              msg: "المكينة موجودة بالفعل",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP_RIGHT,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

        }else{
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const InventoryPage()));
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
    }

    List<Widget> content = [
      Expanded(
        flex: kIsWeb?1:0,
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
            children: [
              const Align(
                alignment: AlignmentDirectional.topEnd,
                child: Text(
                  "الحالة",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF1A1A24),
                    fontSize: 16,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
              getStatusMenu((value) {
                setState(() {
                  selectedValue = value.toString();
                });
              }, (value) {
                setState(() {
                  selectedValue = value.toString();
                });
              }, selectedValue),
              selectedValue != "3"
                  ? Text("")
                  : Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: SizedBox(
                            child: Column(
                              children: [
                                Align(
                                    alignment: AlignmentDirectional.center,
                                    child: ImageDragged(
                                        text: "صورة العقد",
                                        url: "",
                                        photo: setContractImage)),
                                const SizedBox(
                                  height: 10,
                                ),
                                noIconedTextField(
                                    'اسم المستأجر', _clientNameTextController,
                                    onTextChange: (value) {}, height: 40),
                                const SizedBox(
                                  height: 10,
                                ),
                                DatePicker(label: "تاريخ التأجير",
                                    controller: _dateOfContractTextController),
                                const SizedBox(
                                  height: 10,
                                ),DatePicker(label: "تاريخ الانتهاء",
                                    controller: _dateRangTextController),
                                const SizedBox(
                                  height: 10,
                                ),
                                noIconedTextField(
                                    'رقم الهاتف', _phoneTextController,
                                    onTextChange: (value) {}, height: 40),
                                const SizedBox(
                                  height: 10,
                                ),
                                noIconedTextField(
                                    'رقم الهوية', _nationalIdTextController,
                                    onTextChange: (value) {}, height: 40),
                                const SizedBox(
                                  height: 10,
                                ),
                                noIconedTextField(
                                    'رقم الحارس', _guardNumTextController,
                                    onTextChange: (value) {}, height: 40),
                                const SizedBox(
                                  height: 10,
                                ),

                                noIconedTextField(
                                    'رابط العنوان', _addressTextController,
                                    onTextChange: (value) {}, height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
     kIsWeb? const SizedBox(
       width: 24,
     ): const SizedBox(
    height: 24,
    ),
      Expanded(
        flex: kIsWeb?3:0,
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
                    width: kIsWeb? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width*0.7,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: ImageDragged(
                              text: "صورة الماكينة",
                              url: "",
                              photo: setMachineImage),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        noIconedTextArea(
                          'اسم المنتج (إلزامي)',
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
                        const SizedBox(
                          height: 16,
                        ),
                        noIconedTextField('الرقم التعريفي', _codeTextController,
                            onTextChange: (value) {}),
                        const SizedBox(
                          height: 16,
                        ),
                        noIconedTextField('الماركة', _brandTextController,
                            onTextChange: (value) {}),
                        const SizedBox(
                          height: 10,
                        ),
                        splittedTextField(
                            'صيانة المولد كل',
                            _maintanceEverTextController,
                            'يوم',
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
          kIsWeb
              ? const Header(
                  isMain: false,
                )
              : SizedBox(),
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
                child: Column(
                  children: [
                   kIsWeb?  Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: content,
                          ):Column(verticalDirection: VerticalDirection.up,
                     children: content,
                   )
                          ,
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
                'اضافة منتج',
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
            child: subHeaderNoIconButton(
                'اضافة',
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
