import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.design.studiovie/models/firebase_api_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class GalleryDataSource {
  final FirebaseFirestore db;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  GalleryDataSource({
    required this.db,
    required this.storage,
    required this.auth,
  }) {
    // db.collection("gallery").get().then((snapshots) {
    //   print(snapshots.size);
    //   for (var snapshot in snapshots.docs) {
    //     print(snapshot.id);
    //   }
    // }, onError: (e) => print('Error : $e'));
  }

  List<XFile>? images = [];

  Future<List<ResultGalleryItemModel>> fetchGalleryData() async {
    try {
      List<ResultGalleryItemModel> resources = [];

      final QuerySnapshot querySnapshot = await db.collection('gallery').get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        ResultGalleryItemModel result =
            ResultGalleryItemModel.fromJson(querySnapshot.docs[i]);
        resources.add(result);
      }
      return resources;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  searchGallery(String query) async {
    final List<String> fields = ['title', 'role', 'group'];
    List<ResultGalleryItemModel> resources = [];
    final QuerySnapshot querySnapshot = await db
        .collection('gallery')
        .where(fields, arrayContains: query)
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      ResultGalleryItemModel result =
          ResultGalleryItemModel.fromJson(querySnapshot.docs[i]);
      resources.add(result);
    }
    return resources;
  }

  // uploadImages() async {
    // if (Platform.isIOS) {
    //   await Permission.photosAddOnly.request();
    // }
  //   ImagePicker picker = ImagePicker();
  //   images = await picker.pickMultiImage();
  //   print('ready for uploading images');
  // }

  Future sendGalleryData(NewGalleryItemModel newGallery) async {
    try {
      // await db.collection('gallery').doc('test').set({"title": "강남365"});
      DocumentReference docRef = db.collection('gallery').doc();
      images = newGallery.images;
      List<String> imageUrls = [];
      if (images!.isNotEmpty) {
        // print('starting to upload image(s)');
        imageUrls = await uploadImages(docRef, newGallery.title);
      }

      await docRef.set({
        "title": newGallery.title,
        "role": newGallery.role,
        "group": newGallery.group,
        "area": newGallery.area,
        "description": newGallery.description,
        "createdAt": DateTime.now(),
        "userId": auth.currentUser?.uid,
        if (imageUrls.isNotEmpty) "imageUrl": imageUrls
      });
    } on FirebaseException catch (error) {
      print(error);
      rethrow;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<String>> uploadImages(
      DocumentReference docRef, String title) async {
    List<String> imageUrls = [];
    if (images!.isNotEmpty) {
      for (int i = 0; i < images!.length; i++) {
        File file = File(images![i].path);
        TaskSnapshot snapshot = await storage.ref(
            // 'studiovie/${docRef.id}/${DateTime.now().millisecondsSinceEpoch}'
            'studiovie/prod/${docRef.id}/${title} _$i').putFile(file);
        // snapshot.bytesTransferred.toDouble();
        final String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
      return imageUrls;
    }
    return imageUrls;
  }

  Future<void> updateGalleryItem(
      NewGalleryItemModel updateGallery, String docId) async {
    try {
      DocumentReference docRef = db.collection('gallery').doc(docId);
      DocumentSnapshot snapshot = await docRef.get();
      final data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey("imageUrl")) {
        for (var i = 0; i < data['imageUrl'].length; i++) {
          // print('starting to delete image');
          final storageRef = storage.ref();
          final desertRef = storageRef
              // .child('studiovie/${docId}/${createAt.millisecondsSinceEpoch}');
              .child('studiovie/prod/${docRef.id}/${data["title"]} _$i');
          // print('storage to delete : $desertRef');
          await desertRef.delete();
        }
      }
      images = updateGallery.images;
      List<String> imageUrls = [];
      if (images!.isNotEmpty) {
        imageUrls = await uploadImages(docRef, updateGallery.title);
      }

      Map<Object, Object?> updateData = {
        "title": updateGallery.title,
        "role": updateGallery.role,
        "group": updateGallery.group,
        "area": updateGallery.area,
        "description": updateGallery.description,
        "createdAt": DateTime.now(),
        "userId": auth.currentUser?.uid,
        if (imageUrls.isNotEmpty) "imageUrl": imageUrls
      };
      await docRef.update(updateData);
    } catch (error) {
      rethrow;
    } finally {
      // return
    }
  }

  Future deleteGalleryItem(String docId) async {
    try {
      DocumentReference docRef = db.collection('gallery').doc(docId);

      DocumentSnapshot snapshot = await docRef.get();
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('No item to delete');
      }
      //doc에 imageUrl 필드 없을 수 있음.
      if (data.containsKey('imageUrl')) {
        // print('starting to delete image');
        final storageRef = storage.ref();
        for (var i = 0; i < data["imageUrl"].length; i++) {
          final desertRef = storageRef
              // .child('studiovie/${docId}/${createAt.millisecondsSinceEpoch}');
              .child('studiovie/prod/${docRef.id}/${data["title"]} _$i');
          // print('storage to delete : $desertRef');
          await desertRef.delete();
        }
      }

      docRef.delete();
      // print('delete done 🗑️ : ${docRef.id}');
    } on FirebaseException catch (error) {
      print(error);
      rethrow;
    } on Exception catch (error) {
      print('Exception Error Occured : $error');
      throw Error();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getPartnersImageUrl(String partner) async {
    try {
      String imageUrl =
          await storage.ref('studiovie/partners/$partner.png').getDownloadURL();
      // print(imageUrl);
      return imageUrl;
    } on FirebaseException catch (error) {
      print(error);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
