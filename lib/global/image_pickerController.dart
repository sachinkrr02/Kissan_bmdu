import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class imagePickercontroller extends GetxController {
  RxList<XFile> imageList = <XFile>[].obs;
  RxString checqueImage= ''.obs;
  RxString passbookImage= ''.obs;
  RxString KycSs= ''.obs;
  RxString aadharfront= ''.obs;
  RxString aadharback= ''.obs;
  RxString panfront= ''.obs;
  RxString GSTCErtificate= ''.obs;
  RxString image_path = ''.obs;
  Future getImagefromgallery() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      image_path.value = image!.path.toString();
    }
  }

  Future getimagefromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != Null) {
      image_path.value = image!.path.toString();
      
    }
  }

  Future reset() async {
    image_path.value = '';
  }

  Future removeat(int index) async {
    imageList.removeAt(index);
  }

  Future edit(int index) async {
    XFile image = imageList[index];
    final _picker = ImagePicker();
    try {
      final temp_image = await _picker.pickImage(source: ImageSource.gallery);
      if (temp_image != null) {
        imageList[index] = temp_image;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  

  Future getmultipleImage() async {
    final ImagePicker _picker = ImagePicker();
    final selectedImages = await _picker.pickMultiImage(
      imageQuality: 100,
    );

    if (selectedImages.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        imageList.add(selectedImages[i]);
      }
    } else {
      Get.snackbar('Error', 'Please Select Images');
    }
  }
}
