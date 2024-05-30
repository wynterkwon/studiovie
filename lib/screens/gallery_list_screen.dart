import 'package:com.design.studiovie/widgets/base_scaffold.dart';
import 'package:com.design.studiovie/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:com.design.studiovie/models/firebase_api_model.dart';
import 'package:com.design.studiovie/viewmodels/gallery_vm.dart';
import 'package:com.design.studiovie/widgets/project_horizontal.dart';

class GalleryListScreen extends StatefulWidget {
  const GalleryListScreen({super.key});

  @override
  State<GalleryListScreen> createState() => _GalleryListScreenState();
}

class _GalleryListScreenState extends State<GalleryListScreen> {
  late TextEditingController searchController;
  bool isSearching = false;
  bool isAllSelected = true;
  bool isOfficeSelected = false;
  bool isHospitalSelected = false;
  bool isRetailSelected = false;
  bool isOthersSelected = false;
  String query = 'all';

  dynamic getGallery;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  setSeletedDafault() {
    isAllSelected = false;
    isHospitalSelected = false;
    isOfficeSelected = false;
    isRetailSelected = false;
    isOthersSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    // print('building UI');
    return BaseScaffold(
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.home,
            color: Colors.white,
            size: ResponsiveLayout.isPhone(context) ? 28 : 38,
          ),
          tooltip: 'Home',
        ),
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
          icon: isSearching
              ? Icon(
                  Icons.close,
                  color: Colors.white,
                  size: ResponsiveLayout.isPhone(context) ? 30 : 42,
                )
              : Icon(
                  Icons.search,
                  color: Colors.white,
                  size: ResponsiveLayout.isPhone(context) ? 30 : 42,
                ),
          tooltip: 'Search',
        ),
      ],
      body: SafeArea(
        child: Column(
          children: [
            isSearching ? _buildSearchBar() : const SizedBox.shrink(),
            isSearching ? const SizedBox.shrink() : _buildCategory(),
            // _buildFutureGalleryItems(),
            _buildGalleryItems()
          ],
        ),
      ),
    );
  }

  _buildGalleryItems() {
    return Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 158,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: context.read<GalleryViewModel>().copyGalleries.length,
          itemBuilder: (context, index) {
            ResultGalleryItemModel gallery =
                context.read<GalleryViewModel>().copyGalleries[index];
            return ProjectCardHorizontal(gallery: gallery);
          }),
    );
  }

  Column _buildCategory() {
    // print('in build category selected');
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCategoryButton('All', isAllSelected, () async {
                setState(() {
                  setSeletedDafault();
                  isAllSelected = !isAllSelected;
                  context.read<GalleryViewModel>().searchGallery('all');
                });
              }),
              buildCategoryButton('Office', isOfficeSelected, () async {
                setState(() {
                  setSeletedDafault();
                  isOfficeSelected = !isOfficeSelected;
                  context.read<GalleryViewModel>().searchGallery('office');
                });
              }),
              buildCategoryButton('Hospital', isHospitalSelected, () {
                setState(() {
                  setSeletedDafault();
                  isHospitalSelected = !isHospitalSelected;
                  context.read<GalleryViewModel>().searchGallery('hospital');
                });
              }),
              buildCategoryButton('Retail', isRetailSelected, () {
                setState(() {
                  setSeletedDafault();
                  isRetailSelected = !isRetailSelected;
                  context.read<GalleryViewModel>().searchGallery('retail');
                });
              }),
              buildCategoryButton('Others', isOthersSelected, () {
                setState(() {
                  setSeletedDafault();
                  isOthersSelected = !isOthersSelected;
                  context.read<GalleryViewModel>().searchGallery('others');
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildSearchBar() {
    return Column(
      children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.8),
            ),
            hintText: 'ex) office, hospital, retail, 365 ...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          // onChanged: searchGallery,
          onChanged: (value) {
            setState(() {
              query = value;
              context.read<GalleryViewModel>().searchGallery(query);
            });
          },
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }

  TextButton buildCategoryButton(
      String category, bool isSelected, Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: showGalleryByCategory(category, isSelected),
    );
  }

  showGalleryByCategory(String text, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:
              isSelected ? Colors.grey.withOpacity(0.4) : Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveLayout.isPhone(context) ? 18 : 30,
          ),
        ),
      ),
    );
  }
}
