import 'package:contact/model/ContactUserModel.dart';

class UpdateContactUserState {
  late ContactUserModel currentContactUser;

  UpdateContactUserState init() {
    return UpdateContactUserState()
      ..currentContactUser = ContactUserModel();
  }

  UpdateContactUserState clone() {
    return UpdateContactUserState()
      ..currentContactUser = currentContactUser;
  }
}
