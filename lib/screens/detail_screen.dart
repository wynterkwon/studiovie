import 'package:com.design.studiovie/widgets/base_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:com.design.studiovie/models/firebase_api_model.dart';
import 'package:com.design.studiovie/screens/admin_list_screen.dart';
import 'package:com.design.studiovie/screens/admin_screen.dart';
import 'package:com.design.studiovie/viewmodels/admin_vm.dart';
import 'package:com.design.studiovie/viewmodels/auth_vm.dart';
import 'package:com.design.studiovie/viewmodels/gallery_vm.dart';
import 'package:com.design.studiovie/widgets/detailed_gallery_contents.dart';

class DetailedGallery extends StatefulWidget {
  ResultGalleryItemModel gallery;
  DetailedGallery({super.key, required this.gallery});

  @override
  State<DetailedGallery> createState() => _DetailedGalleryState();
}

class _DetailedGalleryState extends State<DetailedGallery> {
  @override
  void initState() {
    super.initState();
  }

  void _showImageNoticePopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notice'),
        content: const Text(
            'In Edit mode, default image set to null. \nIf you select no image(s), it will be updated without any image. \nMake sure you add image(s) when you update gallery item.'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                // _toShowAlarmPopup = false; // Update state
                context.read<AdminViewModel>().setNeverShowImageNotice();
              });
              Navigator.of(context).pop();
            },
            child: const Text('OK, Never Show Again'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel auth = context.read<AuthViewModel>();
    AdminViewModel admin = context.read<AdminViewModel>();
    return BaseScaffold(
      actions: [
        auth.user != null
            ? Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      icon: Icon(Icons.home)),
                  IconButton(
                    onPressed: () {
                      admin.isUpdating = true;
                      admin.titleController.text = widget.gallery.title;
                      admin.roleController.text = widget.gallery.role;
                      admin.areaController.text = widget.gallery.area;
                      admin.descriptionController.text =
                          widget.gallery.description;
                      admin.groupController.text = widget.gallery.group.name;
                      admin.updatingDocId = widget.gallery.docId;

                      Future.delayed(Duration(microseconds: 200), () {
                        bool _toShowImageNotice = context
                            .read<AdminViewModel>()
                            .isNeverShowUpdateImageNoticeChecked;
                        User? user = context.read<AuthViewModel>().user;
                        if (!_toShowImageNotice && user != null) {
                          _showImageNoticePopup();
                        }
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminScreen()));
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm'),
                          content: Text(
                            'Delete selected item(s) \nThis will not be revoked. \nAre you sure you want to delete?',
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('OK'),
                              onPressed: () async {
                                try {
                                  await admin
                                      .deleteGalleryItem(widget.gallery.docId);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Successfully deleted!')),
                                  );

                                  await context
                                      .read<GalleryViewModel>()
                                      .fetchGalleryData(); // 업데이트 데이터 반영?
                                  Future.delayed(
                                    Duration(seconds: 1),
                                    () {
                                      return Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdminListScreen()),
                                      );
                                    },
                                  );
                                } catch (error) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Warning'),
                                      content: Text('Already deleted 🗑️'),
                                    ),
                                  );
                                }
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              )
            : SizedBox(
                width: 20,
              )
      ],
      body: Stack(
        children: [
          context.watch<AdminViewModel>().isUploadingImage
              ? Positioned.fill(
                  child: ModalBarrier(
                    color: Colors.black26,
                    dismissible: false,
                  ),
                )
              : SizedBox.shrink(),
          context.watch<AdminViewModel>().isUploadingImage
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DetailedGalleryContents(
                        name: 'PROJECT', value: widget.gallery.title),
                    DetailedGalleryContents(
                        name: 'AREA', value: widget.gallery.area),
                    DetailedGalleryRoleContents(
                        name: 'ROLE', roles: widget.gallery.role.split(',')),
                    DetailedGalleryContents(
                        name: 'DESCR', value: widget.gallery.description),
                    const SizedBox(
                      height: 10,
                    ),
                    ListBody(
                      children: [
                        for (final img in widget.gallery.imageUrls)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(color: Colors.white),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.network(img)),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
