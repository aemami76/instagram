import 'package:flutter/material.dart';

import '../model/models.dart';

class ProviderUser with ChangeNotifier {
  late MyUser _curUser;

  set curUser(MyUser value) {
    _curUser = value;
    notifyListeners();
  }
}
