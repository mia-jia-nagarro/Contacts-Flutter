import 'package:contact/model/ContactUserModel.dart';

class ContactUserState {
  late List<ContactUserModel> contactUserList;
  late List<ContactUserModel> favoriteUserList;

  ContactUserState init() {
    return ContactUserState()
      ..contactUserList = []
      ..favoriteUserList = [];
  }

  ContactUserState getAllData(List<ContactUserModel> list) {
    return ContactUserState()..contactUserList = list;
  }

  ContactUserState getFavoriteUserList(List<ContactUserModel> list) {
    return ContactUserState()..favoriteUserList = list;
  }

  ContactUserState clone() {
    return ContactUserState()
      ..contactUserList = contactUserList
      ..favoriteUserList = favoriteUserList;
  }
}
