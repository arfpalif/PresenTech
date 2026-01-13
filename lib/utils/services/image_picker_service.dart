import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presentech/shared/styles/color_style.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickAndCropImage({
    required double ratioX,
    required double ratioY,
    String title = 'Edit Photo',
  }) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: title,
            toolbarColor: ColorStyle.colorPrimary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: title,
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking/cropping image: $e');
      return null;
    }
  }
}
