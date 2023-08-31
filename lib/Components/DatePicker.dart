import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const DatePicker({Key? key, required this.controller, required this.label}) : super(key: key);

  @override
  _DatePicker createState() => _DatePicker();
}

class _DatePicker extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.value =
            TextEditingValue(text: picked.toLocal().toString().split(' ')[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: widget.controller,onTap: () {print("sss"); _selectDate(context);},
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              PhosphorIcons.calendar_blank,
              color: Colors.grey,
            ),
            onPressed: () {
              _selectDate(context);
            },
          ),
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }
}
