import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/utils/utils.dart';

class ImageAlert extends StatelessWidget {
  final Function(File?) onImageSelected;

  ImageAlert({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppStrings.cancel)),
      ],
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                File? image = await Utils.getImage(ImageSource.gallery);
                onImageSelected(image);
              },
              label: Text(
                AppStrings.gallery,
              ),
              icon: Icon(Icons.image_outlined),
            ),
          ),
          Flexible(
            child: TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                File? image = await Utils.getImage(ImageSource.camera);
                onImageSelected(image);
              },
              label: Text(
                AppStrings.camera,
              ),
              icon: Icon(Icons.camera_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
