import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UpdateState extends ChangeNotifier {
  void updateState() {
    notifyListeners();
  }
}
