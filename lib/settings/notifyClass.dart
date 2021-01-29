import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UpdateState with ChangeNotifier {
  void updateState() {
    notifyListeners();
  }
}
