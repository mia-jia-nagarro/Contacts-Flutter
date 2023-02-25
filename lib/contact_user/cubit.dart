import 'package:bloc/bloc.dart';
import 'package:contact/db/DatabaseHelper.dart';
import 'package:flutter/material.dart';

import 'state.dart';

class ContactUserCubit extends Cubit<ContactUserState> {
  ContactUserCubit() : super(ContactUserState().init());

  void init() async {
    emit(state.init());
    initDatabase();
  }

  void initDatabase() async {
    await DatabaseHelper.initDatabase();
    _queryAllData();
  }

  void _queryAllData() async {
    state.contactUserList = await DatabaseHelper.queryAllData();
    emit(state.clone());
  }

  void queryFavoriteList() async {
    state.favoriteUserList = await DatabaseHelper.qureyFavoriteData();
    emit(state.clone());
  }

  void jumpToContactsList(BuildContext context) {
    Navigator.of(context).pop();
  }

  void jumpToMyFavorite(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .pushNamed('myFavorite')
        .then((value) => _queryAllData());
  }

  void jumpToAddNewContact(BuildContext context, bool isFromDrawer) {
    if (isFromDrawer) {
      Navigator.of(context).pop();
    }
    Navigator.of(context)
        .pushNamed('addNewContactUser')
        .then((value) => _queryAllData());
  }

  void jumpToUpdateContact(
      BuildContext context, bool isFromFavoritePage, int index) {
    Navigator.of(context)
        .pushNamed('updateContactUser',
            arguments: isFromFavoritePage
                ? state.favoriteUserList[index]
                : state.contactUserList[index])
        .then((value) {
      isFromFavoritePage ? queryFavoriteList() : _queryAllData();
    });
  }
}
