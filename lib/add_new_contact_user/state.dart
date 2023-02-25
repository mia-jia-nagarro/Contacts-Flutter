class AddNewContactUserState {
  late String photoSource;
  late bool isFavorite;

  AddNewContactUserState init() {
    return AddNewContactUserState()
      ..photoSource = ""
      ..isFavorite = false;
  }

  AddNewContactUserState clone() {
    return AddNewContactUserState()
      ..photoSource = photoSource
      ..isFavorite = isFavorite;
  }
}
