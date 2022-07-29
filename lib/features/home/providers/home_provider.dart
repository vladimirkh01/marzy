import 'package:marzy/logic/base/base_provider.dart';

class HomeProvider extends BaseProvider {
  bool _searching = false;

  bool get searching => _searching;

  set setSearching(bool value) {
    _searching = value;
    notifyListeners();
  }

  void search(String? text) {
    print(text);
  }

  String get address => "ул. Карла Маркса 21";
}
