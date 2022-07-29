import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<File?> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        imageQuality: 25,
        source: source
    );
    if (pickedFile != null) {
      File _image = File(pickedFile.path);
      return _image;
    }
    return null;
  }
}
