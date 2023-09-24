import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import 'package:http/http.dart' as http;
import '../ListItems/MachineItem.dart';
import '../Model/MachineCategories.dart';
import '../utilis/Utilis.dart';

Image ImageWidget(String imageName, double width, double height) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: width,
    height: height,
  );
}

Directionality noIconedTextArea(String text, TextEditingController controller,
    {required Function onTextChange}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          onTextChange(value);
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 3,
        decoration: InputDecoration(
          labelText: text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    ),
  );
}

Directionality noIconedTextField(String text, TextEditingController controller,
    {double height = 48, required Function onTextChange}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    ),
  );
}

Directionality splittedTextField(
    String frist, TextEditingController controller, String last,
    {double height = 48}) {
  return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: kIsWeb ?MainAxisAlignment.start:MainAxisAlignment.spaceBetween,
        children: [
          Text(
            frist,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF1A1A24),
              fontSize: 14,
              fontFamily: 'santo',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.10,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Row(
            children: [
              SizedBox(
                height: height,
                width: 80,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                last,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF1A1A24),
                  fontSize: 14,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              )
            ],
          ),
        ],
      ));
}

Directionality IconedTextField(
    String text, IconData icon, TextEditingController controller) {
  return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        cursorColor: Color.fromRGBO(152, 162, 179, 1),
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Color(0xFF98A1B2),
          fontSize: 16,
          fontFamily: 'santo',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.50,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              icon,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
          labelText: text,
          labelStyle: const TextStyle(
              fontFamily: "santo",
              color: Color.fromRGBO(152, 162, 179, 1),
              fontWeight: FontWeight.w400,
              fontSize: 16),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: const Color.fromRGBO(249, 250, 251, 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: Color.fromRGBO(208, 213, 221, 1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: Color.fromRGBO(208, 213, 221, 1),
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ));
}

Directionality IconedActionTextField(String text, IconData icon,
    TextEditingController controller, Function onTap) {
  return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        cursorColor: Color.fromRGBO(152, 162, 179, 1),
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Color(0xFF98A1B2),
          fontSize: 16,
          fontFamily: 'santo',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.50,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              icon,
              color: Colors.blue,
            ),
            onPressed: () {
              onTap();
            },
          ),
          labelText: text,
          labelStyle: const TextStyle(
              fontFamily: "santo",
              color: Color.fromRGBO(152, 162, 179, 1),
              fontWeight: FontWeight.w400,
              fontSize: 16),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: const Color.fromRGBO(249, 250, 251, 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: Color.fromRGBO(208, 213, 221, 1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: Color.fromRGBO(208, 213, 221, 1),
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ));
}

Container signInUpButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color(0x4C068AC8),
          blurRadius: 16,
          offset: Offset(0, 4),
          spreadRadius: 0,
        )
      ],
    ),
    child: ElevatedButton(
      onPressed: () => onTap(),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        shadowColor:
            MaterialStateProperty.all(const Color.fromRGBO(6, 138, 200, 0.3)),
        backgroundColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.pressed)
                ? const Color.fromRGBO(11, 78, 142, 1)
                : const Color.fromRGBO(3, 158, 218, 1)),
      ),
      child: Text(
        isLogin ? "تسجيل الدخول" : "اضافة مستخدم",
        style: const TextStyle(
            fontFamily: "santo",
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    ),
  );
}

Container subHeaderButton(String text, IconData icon, Function onTap,
    {Color color = const Color.fromRGBO(205, 230, 244, 1),
    Color shadow = const Color(0x4C068AC8)}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: shadow,
          blurRadius: 16,
          offset: Offset(0, 4),
          spreadRadius: 0,
        )
      ],
    ),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: text == ''
          ? Container(
              width: 48,
              height: 34,
              decoration: ShapeDecoration(
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: TextButton(
                child: Icon(
                  icon,
                  size: kIsWeb ? 24 : 18,
                  color: const Color(0xFF1A1A24),
                ),
                onPressed: () => {onTap()},
              ),
            )
          : ElevatedButton.icon(
              onPressed: () => {onTap()},
              icon: Icon(
                icon,
                size: 18,
                color: const Color(0xFF1A1A24),
              ),
              label: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF1A1A24),
                  fontSize: 14,
                  fontFamily: 'santo',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.10,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  color,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
    ),
  );
}

Container subHeaderNoIconButton(String text, Function? onTap) {
  return Container(
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color(0x4C068AC8),
          blurRadius: 16,
          offset: Offset(0, 4),
          spreadRadius: 0,
        )
      ],
    ),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton(
        onPressed: onTap != null
            ? () {
                onTap();
              }
            : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            onTap != null
                ? Color.fromRGBO(205, 230, 244, 1)
                : Color.fromRGBO(208, 213, 221, 1),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: onTap != null ? Color(0xFF1A1A24) : Color(0xFF98A1B2),
            fontSize: 14,
            fontFamily: 'santo',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.10,
          ),
        ),
      ),
    ),
  );
}

Directionality listFilter(
    String text, IconData icon, Function onTap, bool isActive) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: TextButton.icon(
      onPressed: () => {onTap()},
      icon: Icon(
        icon,
        size: 24,
        color: isActive ? const Color(0xFF068AC8) : const Color(0xFF98A1B2),
      ),
      label: Text(
        text,
        style: TextStyle(
          color: isActive ? const Color(0xFF068AC8) : const Color(0xFF98A1B2),
          fontSize: 14,
          fontFamily: 'santo',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.10,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? const Color(0xFFCDE6F4) : Colors.white,
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
  );
}

Align getStatusMenu(
    Function onChange, Function onSaved, String? selectedValue) {
  const List<String> list = <String>['1', '2', '3'];
  return Align(
    alignment: AlignmentDirectional.topEnd,
    child: SizedBox(
      width: 170,
      child: Directionality(
        textDirection: TextDirection.rtl,
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
          hint: const Text(
            'اختر',
            style: TextStyle(
              color: Color(0xFF475467),
              fontSize: 12,
              fontFamily: 'santo',
              fontWeight: FontWeight.bold,
              letterSpacing: 0.50,
            ),
          ),
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: StatusItem(
                state: value,
              ),
            );
          }).toList(),
          value: selectedValue,
          validator: (value) {
            if (value == null) {
              return 'اختر';
            }
            return null;
          },
          onChanged: (value) => {onChange(value)},
          onSaved: (value) => {onSaved(value)},
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
    ),
  );
}
