import 'package:flutter/foundation.dart';

class BaseProvider extends ChangeNotifier {
  bool _requestSend = false;
  bool _loading = false;
  bool _viewSetup = false;

  bool get requestSend => _requestSend;

  bool get viewSetup => _viewSetup;

  bool get loading => _loading;

  set setRequestSend(bool value) {
    _requestSend = value;
    notifyListeners();
  }

  set setViewSetup(bool value) {
    _viewSetup = value;
    notifyListeners();
  }

  set setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
