import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:com.design.studiovie/viewmodels/admin_vm.dart';
import 'package:com.design.studiovie/viewmodels/gallery_vm.dart';

Widget buildBody(
  BuildContext context,
  AdminViewModel adminViewModel,
  GlobalKey<FormState> formKey,
) {
  // print('build admin input form body : ${DateTime.now()}');
  return Stack(
    children: [
      Form(
        key: formKey,
        child: Column(
          children: [
            _buildTitleField(adminViewModel),
            SizedBox(
              height: 10,
            ),
            _buildRoleField(adminViewModel),
            SizedBox(
              height: 10,
            ),
            _buildAreaField(adminViewModel),
            SizedBox(
              height: 10,
            ),
            _buildGroupField(adminViewModel),
            SizedBox(
              height: 10,
            ),
            _buildDescriptionField(adminViewModel),
            SizedBox(
              height: 10,
            ),
            _buildImageField(adminViewModel),
            SizedBox(
              height: 10,
            ),
            adminViewModel.isUpdating == false
                ? _buildSubmitButton(context, adminViewModel, formKey)
                : _buildUpdateSubmitButton(context, adminViewModel, formKey),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildTitleField(AdminViewModel viewModel) {
  return renderTextFormField(
    label: 'Title',
    controller: viewModel.titleController,
  );
}

Widget _buildRoleField(AdminViewModel viewModel) {
  return renderTextFormField(
    label: 'Role',
    controller: viewModel.roleController,
  );
}

Widget _buildAreaField(AdminViewModel viewModel) {
  return renderTextFormField(
    label: 'Area',
    controller: viewModel.areaController,
    helperText: 'ex) 424.60 ㎡ / 128.40 py',
  );
}

Widget _buildGroupField(AdminViewModel viewModel) {
  return renderTextFormField(
    label: 'Group',
    controller: viewModel.groupController,
    helperText: '#office, #retail, #hospital, #others',
  );
}

Widget _buildDescriptionField(AdminViewModel viewModel) {
  return renderTextFormField(
    label: 'Description',
    controller: viewModel.descriptionController,
    helperText: ' max 180 characters',
    maxLines: 3,
  );
}

Widget _buildImageField(AdminViewModel viewModel) {
  return GestureDetector(
    onTap: viewModel.uploadImages,
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.7),
              ),
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Consumer<AdminViewModel>(
              builder: (context, adminProvider, _) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 13.0),
                    child: Text(
                      'Upload Images',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  adminProvider.images.length == 0
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 13.0),
                              child: Text(
                                '(${adminProvider.images.length})',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                            ),
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

Widget _buildSubmitButton(BuildContext context, AdminViewModel viewModel,
    GlobalKey<FormState> formKey) {
  return Column(
    children: [
      InkWell(
        child: ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await viewModel.submitForm(context);
              viewModel.freeGalleryResources();
              context.read<GalleryViewModel>().fetchGalleryData();
            }
          },
          child: Text('Save'),
        ),
      ),
    ],
  );
}


Widget _buildUpdateSubmitButton(BuildContext context,
    AdminViewModel adminViewModel, GlobalKey<FormState> formKey) {
  return InkWell(
    child: ElevatedButton(
      onPressed: () async {
        try {
          if (formKey.currentState!.validate()) {
            await adminViewModel.submitUpdateForm(
                context, adminViewModel.updatingDocId);
            adminViewModel.freeGalleryResources();
            context.read<GalleryViewModel>().fetchGalleryData();
          }
        } catch (error) {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text('Something went wrong \n$error'),
                  ));
        }
      },
      child: Text('Update'),
    ),
  );
}

class renderTextFormField extends StatelessWidget {
  renderTextFormField({
    // super.key,
    required this.label,
    required this.controller,
    this.helperText,
    this.maxLines,
    this.obsecureText,
  });

  final String label;
  final TextEditingController controller;
  final String? helperText;
  final int? maxLines;
  final bool? obsecureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        floatingLabelStyle: const TextStyle(color: Colors.red), 
        helperText: helperText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          gapPadding: 10, // label 양쪽의 padding 값
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      maxLines: maxLines,
    );
  }
}
