import 'package:bloc/bloc.dart';
import 'package:contact/model/ContactUserModel.dart';
import 'package:contact/db/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'state.dart';

class UpdateContactUserCubit extends Cubit<UpdateContactUserState> {
  UpdateContactUserCubit() : super(UpdateContactUserState().init());

  ContactUserModel initUserInfo(BuildContext context) {
    ContactUserModel user =
        ModalRoute.of(context)?.settings.arguments as ContactUserModel;
    state.currentContactUser = user;
    emit(state.clone());
    return user;
  }

  void pickerPhoto(BuildContext context) async {
    _pickImage(false);
    Navigator.of(context).pop();
  }

  void pickerCamera(BuildContext context) async {
    _pickImage(true);
    Navigator.of(context).pop();
  }

  void _pickImage(bool isFromCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: isFromCamera ? ImageSource.camera : ImageSource.gallery);
    state.currentContactUser.imagePath = image?.path ?? "";
    emit(state.clone());
  }

  void favoriteUser() async {
    ContactUserModel currentUser = state.currentContactUser;
    currentUser.isFavorite = !(currentUser.isFavorite ?? false);
    await DatabaseHelper.updateUser(
        currentUser.name.toString().trim(), currentUser.toJson());
    emit(state.clone());
  }

  void updateUserInfoAndPop(
      BuildContext context, String name, String mobile, String landline) async {
    if (name.isEmpty || mobile.isEmpty || landline.isEmpty) {
      return;
    }
    ContactUserModel currentContact = state.currentContactUser;
    currentContact.name = name;
    currentContact.mobile = mobile;
    currentContact.landline = landline;
    await DatabaseHelper.updateUser(
        (state.currentContactUser.name??"").trim(), currentContact.toJson());
    Navigator.of(context).pop("Update Success");
  }

  void deleteUser(BuildContext context) async {
    await DatabaseHelper.deleteUser(
        (state.currentContactUser.name??"").trim());
    List<ContactUserModel> contactUserList =
        await DatabaseHelper.queryAllData();
    Navigator.of(context).pop("Delete Success");
  }
}
