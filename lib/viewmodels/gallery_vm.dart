import 'package:flutter/material.dart';
import 'package:com.design.studiovie/models/data/gallery_data_repository.dart';
import 'package:com.design.studiovie/models/firebase_api_model.dart';

class GalleryViewModel extends ChangeNotifier {
  final GalleryRepository _repository;

  GalleryViewModel(this._repository);

  List<ResultGalleryItemModel> _galleries = [];
  List<ResultGalleryItemModel> get galleries => _galleries;

  List<ResultGalleryItemModel> _copyGalleries = [];
  List<ResultGalleryItemModel> get copyGalleries => _copyGalleries;

  Future<List<ResultGalleryItemModel>> fetchGalleryData() async {
    _galleries = await _repository.fetchGalleryData();
    _copyGalleries = _galleries;
    notifyListeners(); //리스트 업데이트시 반영
    return _galleries;
  }

  String query = 'all';

  searchGallery(String query) {
    if (query == 'all') {
      _copyGalleries = _galleries;
    } else {
      final suggestions = _galleries.where((gallery) {
        final title = gallery.title.toLowerCase();
        final roles = gallery.role.split(',');
        final group = gallery.group.name;
        final input = query.toLowerCase();

        if (title.contains(input)) return true;
        for (var role in roles) {
          if (role.toLowerCase().contains(input)) return true;
        }
        if (group.contains(input)) return true;
        return false;
      }).toList();

      _copyGalleries = suggestions;
      notifyListeners();
    }
  }

  Future<String> getPartnersImageUrl(String partner) async {
    return await _repository.getPartnersImageUrl(partner);
  }
}
