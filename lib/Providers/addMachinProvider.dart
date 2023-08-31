import 'package:flutter/cupertino.dart';

class AddMachineProvider extends ChangeNotifier {
  String _title = 'Add Machine';
  bool _isButtonEnabled = false;

  String get title => _title;
  bool get isButtonEnabled => _isButtonEnabled;

  set title(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void setButtonEnabled(bool isEnabled) {
    _isButtonEnabled = isEnabled;
    notifyListeners();
  }
}