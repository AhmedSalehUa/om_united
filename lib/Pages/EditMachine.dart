import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:om_united/Components/DatePicker.dart';
import 'package:om_united/Components/ImageDragged.dart';
import 'package:om_united/Components/Widgets.dart';
import 'package:om_united/Model/Rent.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/Header.dart';
import '../Components/MultipleImageDragged.dart';
import '../ListItems/ClientDropDown.dart';
import '../ListItems/MachineCategoryItem.dart';
import '../Model/Machine.dart';
import '../utilis/Utilis.dart';
import 'AddMachineCategory.dart';
import 'InventoryPage.dart';
import 'MainFragmnet.dart';
import 'MiniFragmnet.dart';

class EditMachine extends StatefulWidget {
  final Machine item;
  final Rent? rent;

  const EditMachine({Key? key, required this.item, this.rent})
      : super(key: key);

  @override
  State<EditMachine> createState() => _EditMachineState();
}

class _EditMachineState extends State<EditMachine> {
  @override
  Widget build(BuildContext context) {
    return MiniFragmnet(
      content: EditMachineForm(
        item: widget.item,
      ),
    );
  }
}

class EditMachineForm extends StatefulWidget {
  final Machine item;

  const EditMachineForm({Key? key, required this.item}) : super(key: key);

  @override
  State<EditMachineForm> createState() => _EditMachineFormState();
}

class _EditMachineFormState extends State<EditMachineForm> {
  String? selectedValue;
  String? selectedCategory;
  String? selectedClient;
  bool isActive = false;

  PlatformFile? _machinePhotos;
  List<PlatformFile>? _contractPhotos;

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _codeTextController = TextEditingController();
  TextEditingController _brandTextController = TextEditingController();
  TextEditingController _maintanceEverTextController = TextEditingController();
  TextEditingController _totalMaintanceCostTextController =
  TextEditingController();
  TextEditingController _macineValueTextController =
  TextEditingController();


  TextEditingController _dateOfContractTextController = TextEditingController();
  TextEditingController _dateRangTextController = TextEditingController();
  TextEditingController _notesTextController = TextEditingController();
  TextEditingController _costTextController = TextEditingController();

  @override
  void initState() {
    setState(() {
      isActive = true;
      selectedValue = widget.item.status;
      selectedCategory = widget.item.category.id.toString();
    });
    _nameTextController.value = TextEditingValue(text: widget.item.name);
    _codeTextController.value = TextEditingValue(
        text: widget.item.code != null ? widget.item.code! : "");
    _brandTextController.value = TextEditingValue(
        text: widget.item.brand != null ? widget.item.brand! : "");
    _maintanceEverTextController.value =
        TextEditingValue(text: widget.item.maintainceEvery!);
    _totalMaintanceCostTextController.value =
        TextEditingValue(text: widget.item.total_maintance_cost!);
    _macineValueTextController.value =
        TextEditingValue(text: widget.item.machine_value!);

    if (widget.item.rent != null) {
      _dateOfContractTextController.value =
          TextEditingValue(text: widget.item.rent!.date);
      _dateRangTextController.value =
          TextEditingValue(text: widget.item.rent!.dateTo);
      _notesTextController.value =
          TextEditingValue(text: widget.item.rent!.notes!);
      _costTextController.value =
          TextEditingValue(text: widget.item.rent!.cost!=null?widget.item.rent!.cost!:"0");
      setState(() {
        selectedClient = widget.item.rent!.client!.id.toString();
      });
    }
    super.initState();
  }

  void setMachineImage(PlatformFile machinePhotos) {
    setState(() {
      _machinePhotos = machinePhotos;
    });
  }

  void setContractImage(List<PlatformFile> imgs) {
    _contractPhotos = imgs;
  }

  late Response response;
  late String progress = "";

  @override
  Widget build(BuildContext context) {
    // print("idget.item!.rent!.attachments!.length>0");
    // print(widget.item!.rent == null);
    List<Widget> catRow = [
      subHeaderButton('', PhosphorIcons.plus_circle, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddMachineCategory()));
      }),
      Row(
        children: [
          MachineCategoryItem(
              onChange: (value) {
                setState(() {
                  selectedCategory = value.toString();
                });
              },
              onSave: (value) {
                setState(() {
                  selectedCategory = value.toString();
                });
              },
              initialValue: selectedCategory == null ? "" : selectedCategory!),
          kIsWeb
              ? Text(
                  "الفئة",
                  style: const TextStyle(
                    color: Color(0xFF1A1A24),
                    fontSize: 14,
                    fontFamily: 'santo',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),
                )
              : SizedBox(),
        ],
      ),
    ];
    Future<void> Submit() async {
      if (_nameTextController.text != "" &&
          _maintanceEverTextController.text != "" &&_macineValueTextController!= ""&&
          selectedCategory != null) {
        if (selectedValue == "3" && selectedClient == null) {
          Fluttertoast.showToast(
            msg: "بيانات فارغة",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          context.loaderOverlay.show();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          var request = http.MultipartRequest(
            "POST",
            Uri.parse("${URL_PROVIDER()}/Machines.php"),
          );
          if (kIsWeb) {
            if (selectedValue == "3") {
              if (_contractPhotos != null) {
                for (var i = 0; i < _contractPhotos!.length; i++) {
                  request.files.add(
                    http.MultipartFile.fromBytes(
                      "rent_file$i",
                      _contractPhotos![i].bytes!,
                      filename: _contractPhotos![i].name,
                    ),
                  );
                }
              }
            }
            if (_machinePhotos != null) {
              request.files.add(
                http.MultipartFile.fromBytes(
                  "file",
                  _machinePhotos!.bytes!,
                  filename: _machinePhotos!.name,
                ),
              );
            }
          } else {
            if (selectedValue == "3") {
              if (_contractPhotos != null) {
                for (var i = 0; i < _contractPhotos!.length; i++) {
                  request.files.add(
                    await http.MultipartFile.fromPath(
                      "rent_file$i",
                      _contractPhotos![i].path!,
                      filename: basename(_contractPhotos![i].path!),
                    ),
                  );
                }
              }
            }
            if (_machinePhotos != null) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  "file",
                  _machinePhotos!.path!,
                  filename: basename(_machinePhotos!.path!),
                ),
              );
            }
          }

          if (selectedValue == "3") {
            request.fields.addAll({
              "id": widget.item.id.toString(),
              "name": _nameTextController.text,
              "code": _codeTextController.text,
              "brand": _brandTextController.text,
              "status": selectedValue == null ? "1" : selectedValue!,
              "imageNum": _contractPhotos != null
                  ? _contractPhotos!.length.toString()
                  : "0",
              "haveImages": widget.item!.rent != null
                  ? widget.item!.rent!.attachments!.length.toString()
                  : "0",
              "category": selectedCategory == null ? "1" : selectedCategory!,
              "rent_maintance_every": _maintanceEverTextController.text,
              "total_maintance_cost": _totalMaintanceCostTextController.text,
              "machine_value": _macineValueTextController.text,
              "rent_user_id": prefs.getInt("id").toString(),
              "rent_date_from": _dateOfContractTextController.text,
              "rent_date_to": _dateRangTextController.text,
              "rent_notes": _notesTextController.text,
              "rent_cost": _costTextController.text,
              "rent_client_id": selectedClient == null ? "1" : selectedClient!,
            });
          } else {
            request.fields.addAll({
              "id": widget.item.id.toString(),
              "name": _nameTextController.text,
              "code": _codeTextController.text,
              "brand": _brandTextController.text,
              "category": selectedCategory == null ? "1" : selectedCategory!,
              "status": selectedValue == null ? "1" : selectedValue!,
              "rent_maintance_every": _maintanceEverTextController.text,
              "total_maintance_cost": _totalMaintanceCostTextController.text,
              "machine_value": _macineValueTextController.text,
            });
          }
          var response = await request.send();

          if (response.statusCode == 200) {
            context.loaderOverlay.hide();
            var responseOnce = await response.stream.bytesToString();

            if (responseOnce.contains("Duplicate entry")) {
              context.loaderOverlay.hide();
              Fluttertoast.showToast(
                  msg: "المكينة موجودة بالفعل",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP_RIGHT,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              context.loaderOverlay.hide();
              var res = json.decode(responseOnce);

              if (res["error"]) {
                context.loaderOverlay.hide();
                Fluttertoast.showToast(
                    msg: res["message"],
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP_RIGHT,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                context.loaderOverlay.hide();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainFragmnet(
                            subHeader: SizedBox(),
                            content: SizedBox(),
                            isMainWidget: false,
                            selectedIndex: 1)));
                Fluttertoast.showToast(
                    msg: "تم التعديل",
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
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          }
        }
      } else {
        // print("object");
        Fluttertoast.showToast(
          msg: "بيانات فارغة",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }

    List<Widget> content = [
      Expanded(
        flex: kIsWeb ? 1 : 0,
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
                selectedValue = value.toString();
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
                                  child: MultipleImageDragged(
                                    text: 'صور أو فيديو',
                                    url: widget.item!.rent != null
                                        ? widget.item!.rent!.attachments!
                                        : [],
                                    photos: setContractImage,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ClientDropDown(
                                  onChange: (value) {
                                    setState(() {
                                      selectedClient = value.toString();
                                    });
                                  },
                                  onSave: (value) {
                                    setState(() {
                                      selectedClient = value.toString();
                                    });
                                  },
                                  initialValue: selectedClient == null
                                      ? ""
                                      : selectedClient!,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DatePicker(
                                    label: "تاريخ التأجير",
                                    controller: _dateOfContractTextController),
                                const SizedBox(
                                  height: 10,
                                ),
                                DatePicker(
                                    label: "تاريخ الانتهاء",
                                    controller: _dateRangTextController),
                                const SizedBox(
                                  height: 10,
                                ),
                                noIconedTextField(
                                  'قيمة الايجار',
                                  _costTextController,
                                  onTextChange: (value) {},
                                ),const SizedBox(
                                  height: 10,
                                ),
                                noIconedTextArea(
                                  'ملاحظات',
                                  _notesTextController,
                                  onTextChange: (value) {},
                                ),
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
      kIsWeb
          ? const SizedBox(
              width: 24,
            )
          : const SizedBox(
              height: 24,
            ),
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
                              text: "صورة الماكينة",
                              url: widget.item.imageUrl!,
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
                        kIsWeb
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: catRow,
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                verticalDirection: VerticalDirection.up,
                                children: catRow,
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        splittedTextField('صـيـانـة المـولـد كـل',
                            _maintanceEverTextController, 'يوم',
                            height: 40),
                        const SizedBox(
                          height: 10,
                        ),
                        splittedTextField(
                            kIsWeb ? 'اجمالي صيانة المولد' : 'اجمالي الصيانات',
                            _totalMaintanceCostTextController,
                            'ريال',
                            height: 40),
                        const SizedBox(
                          height: 10,
                        ),
                        splittedTextField(
                            'قـيـمـــة الـمــولــــد'  ,
                            _macineValueTextController,
                            'ريال',
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
                    kIsWeb
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: content,
                          )
                        : Column(
                            children: content,
                            verticalDirection: VerticalDirection.up),
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
      padding: kIsWeb
          ? const EdgeInsets.all(15)
          : const EdgeInsets.fromLTRB(15, 50, 15, 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'تعديل منتج',
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
                  size: kIsWeb ? 24 : 18,
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
