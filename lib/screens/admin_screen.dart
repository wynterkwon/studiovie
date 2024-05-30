import 'package:com.design.studiovie/widgets/build_admin_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:com.design.studiovie/models/data/auth_repository.dart';
import 'package:com.design.studiovie/screens/admin_list_screen.dart';
import 'package:com.design.studiovie/viewmodels/admin_vm.dart';
import 'package:com.design.studiovie/viewmodels/auth_vm.dart';
import 'package:com.design.studiovie/widgets/admin_scaffold.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> authKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      actions: [
        Consumer<AuthViewModel>(
          builder: (context, auth, _) => Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AdminListScreen();
                  }));
                },
                icon: auth.user != null
                    ? const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )
                    : const SizedBox.shrink(),
                tooltip: 'Gallery List to edit',
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                icon: auth.user != null
                    ? const Icon(
                        Icons.home,
                        color: Colors.white,
                      )
                    : const SizedBox.shrink(),
                tooltip: 'Home',
              ),
              IconButton(
                onPressed: () async {
                  await auth.signOut();
                },
                icon: auth.user != null
                    ? const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      )
                    : const SizedBox.shrink(),
                tooltip: 'Exit',
              ),
            ],
          ),
        ),
      ],
      body: Stack(
        children: [
          context.watch<AdminViewModel>().isUploadingImage
              ? Positioned.fill(
                  child: ModalBarrier(
                    color: Colors.black26, 
                    dismissible:
                        false, 
                  ),
                )
              : SizedBox.shrink(),
          context.watch<AdminViewModel>().isUploadingImage
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      '🔐 This page is for Admin only',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        context.watch<AuthViewModel>().user != null
                            ? Consumer<AdminViewModel>(
                                builder: (context, admin, child) =>
                                    buildBody(context, admin, formKey),
                              )
                            : Consumer<AuthViewModel>(
                                builder: (context, auth, child) =>
                                    _buildLogin(context, auth, authKey),
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

  Widget _buildLogin(
    BuildContext context,
    AuthViewModel authProvider,
    GlobalKey<FormState> authKey,
  ) {
    return Form(
      key: authKey,
      child: Column(
        children: [
          renderTextFormField(
            label: 'Email',
            controller: authProvider.emailController,
            helperText: 'abc@example.com',
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: authProvider.passwordController,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              label: Text(
                'Password',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              labelStyle: TextStyle(color: Colors.white),

              helperText: 'at least 6 digits',
              floatingLabelStyle: const TextStyle(color: Colors.red), // ?
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                gapPadding: 10, // label 양쪽의 padding 값
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (authKey.currentState!.validate()) {
                try {
                  authKey.currentState!.save();
                  await authProvider.signIn();
                  authProvider.disposeLoginControllers();
                } on AuthError catch (err) {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('Error : ${err.message}'),
                        );
                      });
                }
              }
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
