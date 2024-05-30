import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:com.design.studiovie/models/data/gallery_data_repository.dart';
import 'package:com.design.studiovie/models/firebase_api_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminViewModel extends ChangeNotifier {
  final GalleryRepository _repository;

  AdminViewModel(this._repository) {
    getNeverShow();
  }


  TextEditingController titleController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<XFile> images = [];

  late NewGalleryItemModel newGallery;

  bool isUpdating = false;
  String updatingDocId = '';
  double valueProgress = 0.0;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isNeverShowAlarmChecked = false;
  bool isNeverShowUpdateImageNoticeChecked = false;

  bool isUploadingImage = false;

  toggleIsUploading() {
    isUploadingImage = !isUploadingImage;
    notifyListeners();
  }

  Future<void> submitForm(BuildContext context) async {
    newGallery = NewGalleryItemModel(
      title: titleController.text,
      role: titleController.text,
      area: areaController.text,
      group: groupController.text,
      description: descriptionController.text,
      images: images,
    );
    toggleIsUploading();
    await _repository.sendGalleryData(newGallery);
    toggleIsUploading();

    // 성공 시 알림 및 화면 이동
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully saved!')),
    );
  }

  Future<void> submitUpdateForm(BuildContext context, String docId) async {
    newGallery = NewGalleryItemModel(
      title: titleController.text,
      role: roleController.text,
      area: areaController.text,
      group: groupController.text,
      description: descriptionController.text,
      images: images,
    );
    toggleIsUploading();
    await _repository.updateGalleryItem(newGallery, docId);
    toggleIsUploading();

    // 성공 시 알림 및 화면 이동
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully updated!')),
    );
  }

  deleteGalleryItems(Set toDeleteItems) async {
    for (var docId in toDeleteItems) {
      await _repository.deleteGalleryItem(docId);
    }
    // 성공 시 알림 및 화면 이동
  }

  deleteGalleryItem(String docId) async {
    await _repository.deleteGalleryItem(docId);
  }

  uploadImages() async {
    if (Platform.isIOS) {
      await Permission.photosAddOnly.request();
    }
    ImagePicker picker = ImagePicker();

    images = await picker.pickMultiImage();
    notifyListeners();
  }

//To release image counter after uploading the image(s)
  freeImageList() {
    images = [];
    notifyListeners();
  }

  getNeverShow() async {
    SharedPreferences prefs = await _prefs;
    isNeverShowAlarmChecked = prefs.getBool('isNeverShow') ?? false;
  }

  setNeverShow() async {
    SharedPreferences prefs = await _prefs;
    prefs
        .setBool('isNeverShow', true)
        .then((_) => isNeverShowAlarmChecked = true);
  }

  getNeverShowImageNotice() async {
    SharedPreferences prefs = await _prefs;
    isNeverShowUpdateImageNoticeChecked =
        prefs.getBool('isNeverShowImageNotice') ?? false;
  }

  setNeverShowImageNotice() async {
    SharedPreferences prefs = await _prefs;
    prefs
        .setBool('isNeverShowImageNotice', true)
        .then((value) => isNeverShowUpdateImageNoticeChecked = value);
  }

  @override
  void dispose() {
    titleController.dispose();
    areaController.dispose();
    groupController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  freeGalleryResources() {
    titleController.text = '';
    areaController.text = '';
    groupController.text = '';
    roleController.text = '';
    descriptionController.text = '';
    freeImageList();
    isUpdating = false;
    valueProgress = 0.0;
  }
}
