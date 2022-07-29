import 'dart:io';

import 'package:marzy/features/auth/base/auth_provider.dart';

class VerificationProvider extends AuthProvider {
  File? passportImage;
  File? passportSelfie;

  void setPassportImage(File? image) {
    passportImage = image;
    notifyListeners();
  }

  void setPassportSelfie(File? image) {
    passportSelfie = image;
    notifyListeners();
  }
}
