import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker picker = ImagePicker();
  static Future<File?> pickImageFromGalerry() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      return File(file.path);
    } else {
      return null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (file != null) {
      return File(file.path);
    } else {
      return null;
    }
  }
}
