import 'dart:io';

import 'package:com.design.studiovie/models/data/data_source.dart';
import 'package:com.design.studiovie/models/firebase_api_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:studiovie/models/data/data_source.dart';
// import 'package:studiovie/models/firebase_api_model.dart';

class GalleryRepository {
  final GalleryDataSource dataSource;
  GalleryRepository(
    this.dataSource
  );
  
  // List<GalleryItemsModel> _galleries = [];
  // List<GalleryItemsModel> get galleries => _galleries;
  // List<XFile> images = [];
  // List<String> imageUrls = [];

  Future<List<ResultGalleryItemModel>> fetchGalleryData () async {
    try {
      return await dataSource.fetchGalleryData();
      // _galleries = await dataSource.fetchGalleryData();
    } catch (error) {
      rethrow;
    }

  }

  Future<List<GalleryItemsModel>> searchGallery(String query) async {
    return await dataSource.searchGallery(query);
  }

  // Future uploadImages(images) async {
  //   return await dataSource.uploadImages();
  // }

  Future sendGalleryData(NewGalleryItemModel newGallery) async{
    await dataSource.sendGalleryData(newGallery);
  }

  Future deleteGalleryItem(String docId) async {
    await dataSource.deleteGalleryItem(docId);
  }

  Future updateGalleryItem(NewGalleryItemModel updateGallery, String docId) async{
    await dataSource.updateGalleryItem(updateGallery, docId);
  }

  // uploadImages() async {
  //   if (Platform.isIOS) {
  //     await Permission.photosAddOnly.request();
  //   }
  //   ImagePicker picker = ImagePicker();
  //   images = await picker.pickMultiImage();
  //   // print('ready for uploading images');
  //   // if (images.isNotEmpty) {
  //   //     for (int i = 0; i < images.length; i++) {
  //   //       File file = File(images[i].path);
  //   //       TaskSnapshot snapshot = await _storage
  //   //           .ref(
  //   //               'studiovie/${docRef.id}/${DateTime.now().millisecondsSinceEpoch}')
  //   //           .putFile(file);
  //   //       final String imageUrl = await snapshot.ref.getDownloadURL();
  //   //       imageUrls.add(imageUrl);
  //   //     }
  //   //   }
  // }

  Future<String> getPartnersImageUrl(String partner) async {
    return await dataSource.getPartnersImageUrl(partner);
  }
}