import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:om_united/Model/MachineCategories.dart';
import 'package:om_united/utilis/Utilis.dart';
import 'package:http/http.dart' as http;


class MachineCategoryItem extends StatefulWidget {
 final Function onChange;final Function  onSave ;
 final String  initialValue;
  const MachineCategoryItem({Key? key,required this.onChange,required this.onSave,required this.initialValue }) : super(key: key);

  @override
  State<MachineCategoryItem> createState() => _MachineCategoryItemState();
}

class _MachineCategoryItemState extends State<MachineCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return AddMachineForm(onChange: widget.onChange,onSave: widget.onSave,initialValue: widget.initialValue,);
  }
}

class AddMachineForm extends StatefulWidget {
  final Function onChange;final Function  onSave ;
  final String  initialValue;
  const AddMachineForm({Key? key,required this.onChange,required this.onSave,required this.initialValue}) : super(key: key);

  @override
  State<AddMachineForm> createState() => _AddMachineFormState();
}

class _AddMachineFormState extends State<AddMachineForm> {
  late Future<List<MachineCategories>> _futureItems;

  String? selectedValue;

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
    setState(() {
      if(widget.initialValue!="")selectedValue= widget.initialValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MachineCategories>>(
      future: _futureItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: kIsWeb?350:250,
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
                hint: Align( alignment: AlignmentDirectional.centerEnd,
                  child: const Text(
                    'اختر فئة',
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
                    child: miniCategory (cat : item),
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
            ),
          );

        } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class miniCategory extends StatefulWidget {
  final MachineCategories cat ;
  const miniCategory({Key? key,required this.cat}) : super(key: key);

  @override
  State<miniCategory> createState() => _miniCategoryState();
}

class _miniCategoryState extends State<miniCategory> {
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
                  widget.cat.weight_to,
                  style: TextStyle(fontSize:  14),
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
                  widget.cat.weight_from,
                  style: TextStyle(fontSize:  14),
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
          onPressed:null,
          elevation: 2.0,
          fillColor:
          const Color.fromRGBO(205, 230, 244, 1),
          shape: const CircleBorder(),
          child: Text(
            widget.cat.name,
            style: TextStyle(fontSize: 12),
          ),
        ),

      ],
    );
  }
}

