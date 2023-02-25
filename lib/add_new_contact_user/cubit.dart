import 'package:bloc/bloc.dart';
import 'package:contact/model/ContactUserModel.dart';
import 'package:contact/db/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'state.dart';

class AddNewContactUserCubit extends Cubit<AddNewContactUserState> {
  AddNewContactUserCubit() : super(AddNewContactUserState().init());

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
    state.photoSource = image?.path ?? "";
    emit(state.clone());
  }

  void favoriteUser() {
    state.isFavorite = !state.isFavorite;
    emit(state.clone());
  }

  void saveUserInfo(BuildContext context, String name, String mobileNumber,
      String landline) async {
    if (name.isEmpty || mobileNumber.isEmpty || landline.isEmpty) {
      return;
    }
    ContactUserModel model = ContactUserModel();
    model.name = name;
    model.mobile = mobileNumber;
    model.landline = landline;
    model.isFavorite = state.isFavorite;
    model.imagePath = state.photoSource;
    await DatabaseHelper.insertData(model.toJson());
    Navigator.of(context).pop("Save Success");
  }
}
