import 'package:com.design.studiovie/models/firebase_api_model.dart';
import 'package:com.design.studiovie/viewmodels/gallery_vm.dart';
import 'package:com.design.studiovie/widgets/base_scaffold.dart';
import 'package:com.design.studiovie/widgets/project_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerGalleryScreen extends StatelessWidget {
  String query;
  PartnerGalleryScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 158,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount:
                    context.read<GalleryViewModel>().copyGalleries.length,
                itemBuilder: (context, index) {
                  ResultGalleryItemModel gallery =
                      context.read<GalleryViewModel>().copyGalleries[index];
                  return ProjectCardHorizontal(gallery: gallery);
                }),
          ),
        ],
      ),
    );
  }
}
