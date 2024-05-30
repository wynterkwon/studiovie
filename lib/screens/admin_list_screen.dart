import 'package:com.design.studiovie/models/firebase_api_model.dart';
import 'package:com.design.studiovie/viewmodels/admin_vm.dart';
import 'package:com.design.studiovie/viewmodels/gallery_vm.dart';
import 'package:com.design.studiovie/widgets/admin_scaffold.dart';
import 'package:com.design.studiovie/widgets/project_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminListScreen extends StatefulWidget {
  const AdminListScreen({super.key});

  @override
  State<AdminListScreen> createState() => _AdminListScreenState();
}

class _AdminListScreenState extends State<AdminListScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ResultGalleryItemModel> items = [];
  Set<String> selectedIndices = {};
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      bool _toShowAlarmPopup =
          !context.read<AdminViewModel>().isNeverShowAlarmChecked;
      if (_toShowAlarmPopup) {
        _showAlarmPopup();
      }
      ;
    });

    items = context.read<GalleryViewModel>().galleries;

    super.initState();
  }

  void _showAlarmPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notice'),
        content: const Text('Long press the item(s) you want to delete'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                context.read<AdminViewModel>().setNeverShow();
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
    // print('admin list screen : ${DateTime.now()}');
    return MyScaffold(
      leading: SizedBox.shrink(),
      actions: [
        selectedIndices.length != 0
            ? Text(
                '(${selectedIndices.length})',
                style: TextStyle(color: Colors.red.shade400, fontSize: 24),
              )
            : SizedBox.shrink(),
        // IconButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/admin');
        //     },
        //     icon: Icon(Icons.upload_file)),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin');
            },
            child: Text(
              '🔐',
              style: TextStyle(fontSize: 22),
            )),
        // IconButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/');
        //     },
        //     icon: Icon(
        //       Icons.home,
        //       // size: 30,
        //     )),
        IconButton(
          onPressed: () {
            selectedIndices.isEmpty
                ? showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Nothing to delete'),
                    ),
                  )
                : showDialogDeleteConfirm(context);
          },
          icon: Icon(
            Icons.delete_forever,
            color: selectedIndices.isEmpty
                ? Colors.black26
                : Color.fromARGB(255, 36, 1, 43),
            size: 28,
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ...items.asMap().entries.map((e) {
                int index = e.key;
                String item = e.value.docId;
                if (index < items.length - 1) {
                  return ListTile(
                    onLongPress: () {
                      setState(() {
                        if (selectedIndices.contains(item)) {
                          selectedIndices.remove(item);
                        } else {
                          selectedIndices.add(item);
                        }
                      });
                    },
                    title: ProjectCardHorizontal(
                      gallery: e.value,
                      selectedIndices: selectedIndices,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No More Items',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDialogDeleteConfirm(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text(
          'Delete selected item(s) \nThis will not be revoked. \nAre you sure you want to delete?',
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('OK'),
            onPressed: () async {
              await context
                  .read<AdminViewModel>()
                  .deleteGalleryItems(selectedIndices);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully deleted!')),
              );
              context.read<GalleryViewModel>().fetchGalleryData().then((value) {
                selectedIndices = {};
                items = value;
              });
              Future.delayed(Duration(seconds: 1), () {
                setState(() {
                });
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
