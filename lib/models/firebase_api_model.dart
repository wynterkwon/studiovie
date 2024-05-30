// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.design.studiovie/constants/enums.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:studiovie/constants/enums.dart';

class GalleryItemsModel {
  String title;
  String role;
  String area;
  String group;
  List<XFile>? images;
  // String userId;

  GalleryItemsModel({
    required this.title,
    required this.role,
    required this.area,
    required this.group,
    this.images,
    // required this.userId,
  });
}

class NewGalleryItemModel extends GalleryItemsModel {
  String? description;
  NewGalleryItemModel({
    this.description,
    required title,
    required role,
    required area,
    required group,
    images,
    // required userId,
  }) : super(
          title: title,
          role: role,
          area: area,
          group: group,
          images: images,
        );
}

class ResultGalleryItemModel {
  // late String title;
  String description;
  List<dynamic> imageUrls;
  String userId;
  String title;
  String role;
  String area;
  ProjectsKinds group;
  String docId;
  ResultGalleryItemModel({
    required this.description,
    required this.imageUrls,
    required this.userId,
    required this.title,
    required this.role,
    required this.area,
    required this.group,
    required this.docId,
  });
  // ResultGalleryItemModel(
  //     {required title,
  //     required role,
  //     required area,
  //     required group,
  //     required imageUrls,
  //     required description,
  //     required userId});

  factory ResultGalleryItemModel.fromJson(QueryDocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    // List<dynamic>? imageUrls = [];
    final groupKinds = ProjectsKinds.values.firstWhere(
      (element) => element.name == json['group'],
      orElse: () => ProjectsKinds.none,
    );
    // print('what is json[imageUrl]? : ${json['imageUrl']}');
    // print('doc.id? ${doc.id}');
    // if (json['imageUrl'] == null) {
    //   imageUrls = [];
    // } else {
    //   imageUrls = json['imageUrl'];
    // }
    return ResultGalleryItemModel(
      title: json['title'],
      role: json['role'],
      area: json['area'],
      group: groupKinds,
      imageUrls: json['imageUrl'] ?? [],
      userId: json['userId'],
      description: json['description'] ?? '',
      docId: doc.id,
    );
  }
}
