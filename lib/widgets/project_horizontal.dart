import 'package:com.design.studiovie/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:com.design.studiovie/constants/enums.dart';
import 'package:com.design.studiovie/models/firebase_api_model.dart';
import 'package:com.design.studiovie/screens/detail_screen.dart';
import 'package:com.design.studiovie/utils/group_converter.dart';
import 'package:com.design.studiovie/widgets/project_leading.dart';

class ProjectCardHorizontal extends StatelessWidget {
  ResultGalleryItemModel gallery;
  Set<String>? selectedIndices;
  ProjectCardHorizontal({
    Key? key,
    required this.gallery,
    this.selectedIndices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    if (selectedIndices != null) {
      if (selectedIndices!.contains(gallery.docId)) {
        isSelected = true;
      }
    }
    String? imgUrl;
    if (gallery.imageUrls.isNotEmpty) {
      imgUrl = gallery.imageUrls[0];
    } else {
      imgUrl = null;
    }
    IconData icon = GroupConverter.toIcon(
      group: gallery.group,
    );
    List<Color> groupIconGradient =
        GroupConverter.toGradient(group: gallery.group);
    ProjectsKinds group = gallery.group;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedGallery(gallery: gallery),
            ),
          );
        },
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 10, top: 20, left: 20, right: 20),
          decoration: imgUrl != null
              ? BoxDecoration(
                  color: isSelected
                      ? Color.fromARGB(49, 248, 103, 89)
                      : Color.fromARGB(50, 105, 106, 106),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      opacity: isSelected ? 0.0 : 0.5,
                      image: Image.network(imgUrl).image,
                      fit: BoxFit.cover),
                )
              : BoxDecoration(
                  color: isSelected
                      ? Color.fromARGB(49, 248, 103, 89)
                      : Color.fromARGB(48, 145, 149, 149),
                  borderRadius: BorderRadius.circular(20),
                ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectLeading(
                      icon: icon, gradient: groupIconGradient, group: group),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            gallery.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  ResponsiveLayout.isPhone(context) ? 20 : 30,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      Text(
                        ' 더보기',
                        style: TextStyle(
                            color: Color.fromARGB(255, 245, 246, 248),
                            fontSize:
                                ResponsiveLayout.isPhone(context) ? 20 : 28),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
