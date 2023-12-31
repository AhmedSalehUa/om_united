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
import 'package:om_united/ListItems/AssetsMultiListItem.dart';
import 'package:om_united/ListItems/MachineCategoryItem.dart';
import 'package:om_united/FormPages/AddMachineCategory.dart';
import 'package:om_united/Pages/Inventory.dart';
import 'package:om_united/utilis/Utilis.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/MultipleImageDragged.dart';
import '../Fragments/MobileFragment.dart';
import '../Fragments/WebFragment.dart';
import '../ListItems/AssetsListItem.dart';
import '../ListItems/ClientDropDown.dart';
import '../Model/Assets.dart';
import '../Model/AssetsCategory.dart';
import '../Model/MachineCategories.dart';
import '../Pages/AssetCategoryItems.dart';
import 'AddClientTemp.dart';
import '../Fragments/MiniFragmnet.dart';
import 'package:http/http.dart' as http;

import 'AssetsSelection.dart';

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
  TextEditingController _macineValueTextController = TextEditingController();

  TextEditingController _dateOfContractTextController = TextEditingController();
  TextEditingController _dateRangTextController = TextEditingController();
  TextEditingController _costTextController = TextEditingController();
  TextEditingController _notesTextController = TextEditingController();

  void setMachineImage(PlatformFile machinePhotos) {
    setState(() {
      _machinePhotos = machinePhotos;
    });
  }

  void setContractImage(List<PlatformFile> imgs) {
    _contractPhotos = imgs;
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
  void initState() {
    super.initState();
  }

  List<Assets> RentAssets = [];
  List<int> RentAssetsIDS = [];
  @override
  Widget build(BuildContext context) {
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
            initialValue: "",
          ),
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
          _macineValueTextController != "" &&
          _maintanceEverTextController != "" &&
          selectedValue != "" &&
          selectedCategory != "") {
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
          request.files.add(
            http.MultipartFile.fromBytes(
              "file",
              _machinePhotos!.bytes!,
              filename: _machinePhotos!.name,
            ),
          );
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
            "name": _nameTextController.text,
            "code": _codeTextController.text,
            "brand": _brandTextController.text,
            "status": selectedValue == null ? "1" : selectedValue!,
            "imageNum": _contractPhotos != null
                ? _contractPhotos!.length.toString()
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
            "rent_assets":"["+RentAssetsIDS.join(',')+"]"
          });
        } else {
          request.fields.addAll({
            "name": _nameTextController.text,
            "code": _codeTextController.text,
            "brand": _brandTextController.text,
            "category": selectedCategory == null ? "1" : selectedCategory!,
            "status": selectedValue == null ? "1" : selectedValue!,
            "machine_value": _macineValueTextController.text,
            "rent_maintance_every": _maintanceEverTextController.text,
            "total_maintance_cost": _totalMaintanceCostTextController.text,
          });
        }
        var response = await request.send();

        if (response.statusCode == 200) {
          context.loaderOverlay.hide();
          var responseOnce = await response.stream.bytesToString();
          // print(responseOnce);
          if (responseOnce.contains("Duplicate entry")) {
            Fluttertoast.showToast(
                msg: "المكينة موجودة بالفعل",
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
                  builder: (context) => kIsWeb
                      ? WebFragment(
                          selectedIndex: 1,
                        )
                      : MobileFragment(
                          selectedIndex: 1,
                        ),
                ),
              );
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
      selectedValue != "3"
          ? SizedBox()
          : Expanded(
              flex: kIsWeb ? 1 : 0,
              child: Wrap(
                children: [
                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side:
                            const BorderSide(width: 0.50, color: Color(0x14344054)),
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Text(
                            "الملحقات",
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
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: subHeaderButton(
                            kIsWeb ? RentAssets.length>0?"تعديل": "اضافة" : '',
                            RentAssets.length>0? PhosphorIcons.pencil_simple: PhosphorIcons.plus_circle,
                            () {
                              showModalBottomSheet<Map>(
                                context: context,
                                elevation: 2,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 0.50, color: Color(0x14344054)),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(21),
                                      topLeft: Radius.circular(21)),
                                ),
                                builder: (BuildContext context) {
                                  final screenHeight =
                                      MediaQuery.of(context).size.height;
                                  final desiredHeight = screenHeight *
                                      0.9; // set the height to 90% of the screen height
                                  return Container(
                                    height: desiredHeight,
                                    child: AssetsSelection(list :RentAssets),
                                  );
                                },
                              ).then((value) {
                                if (value != null) {
                                  List<int> selected = value["selected"];
                                  List<Assets> assets =   value["assets"];
                                  List<Assets> returnList = [];
                                  List<int> returnListIDS = [];
                                  assets.forEach((e) {
                                    Assets asset = e;
                                    bool found = false;
                                    selected.forEach((m) {
                                      if (m == e.id) {
                                        found = true;
                                      }
                                    });
                                    if (found) {
                                      returnList.add(asset);
                                      returnListIDS.add(asset.id);
                                    }
                                  });
                                  setState(() {
                                    RentAssets = returnList;
                                    RentAssetsIDS = returnListIDS;
                                  });
                                }
                              });
                            },
                            color: const Color.fromRGBO(205, 230, 244, 1),
                          ),
                        ),
                        RentAssets.length > 0
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: RentAssets.length * 100,
                                child: GridView.builder(  
                                  physics:ScrollPhysics(),
                                  itemCount: RentAssets.length,
                                  cacheExtent: 9999,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: 20,
                                    crossAxisCount: 2   ,mainAxisSpacing: 150,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    final item = RentAssets[index];
                                    return GestureDetector(
                                      onTap: () async {},
                                      child: AssetsMultiListItem(
                                        item: item,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                ],
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
        flex: kIsWeb ? 1 : 0,
        child: Column(
          children: [
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
                                      child: MultipleImageDragged(
                                        text: 'صور أو فيديو',
                                        url: [],
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
                                        initialValue: ""),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    DatePicker(
                                        label: "تاريخ التأجير",
                                        controller:
                                            _dateOfContractTextController),
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
                                    ),
                                    const SizedBox(
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
          ],
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
        flex: kIsWeb ? selectedValue != "3"?3:2 : 0,
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
                        splittedTextField(kIsWeb ? 'قـيـمـــة الـمــولــــد' :"قيمة المولد",
                            _macineValueTextController, 'ريال',
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
