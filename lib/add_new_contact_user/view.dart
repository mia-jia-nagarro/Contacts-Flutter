import 'dart:io';

import 'package:contact/add_new_contact_user/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit.dart';

class AddNewContactUserPage extends StatefulWidget {
  const AddNewContactUserPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddNewContactUserState();
}

class _AddNewContactUserState extends State<AddNewContactUserPage> {
  late AddNewContactUserCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddNewContactUserCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    cubit = BlocProvider.of<AddNewContactUserCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add New Contact",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          BlocBuilder<AddNewContactUserCubit, AddNewContactUserState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    cubit.favoriteUser();
                  },
                  icon: Icon(
                      cubit.state.isFavorite ? Icons.star : Icons.star_border));
            },
          )
        ],
      ),
      body: BlocBuilder<AddNewContactUserCubit, AddNewContactUserState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                        onTap: _showAlert,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          backgroundImage:
                          const AssetImage("assets/images/camera.png"),
                          foregroundImage: FileImage(File(cubit.state
                              .photoSource)),
                        )),
                  ),
                ),
                Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Center(
                                child: Text("Name"),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 20))
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Center(
                                child: Text("Mobile"),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: TextField(
                                controller: mobileController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 20))
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Center(
                                child: Text("Landline"),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: TextField(
                                controller: landlineController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 20))
                          ],
                        ),
                      ],
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: MaterialButton(
                        onPressed: () {
                          cubit.saveUserInfo(context, nameController.text,
                              mobileController.text, landlineController.text);
                        },
                        child: const ListTile(
                          title: Center(
                            child: Text("Save"),
                          ),
                        ),
                      ),
                    ))
              ],
            );
          })
      ,
    );
  }

  void _showAlert() {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 150,
            child: Column(
              children: [
                // Center(
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                ListTile(
                    title: const Center(
                      child: Text("拍照"),
                    ),
                    onTap: () {
                      cubit.pickerCamera(context);
                    }),
                ListTile(
                    title: const Center(
                      child: Text("从相册选择"),
                    ),
                    onTap: () {
                      cubit.pickerPhoto(context);
                    }),
              ],
            ),
          );
        });
  }

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final landlineController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    landlineController.dispose();
    super.dispose();
  }
}
