import 'dart:io';

import 'package:contact/contact_user/cubit.dart';
import 'package:contact/contact_user/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFavoriteContacts extends StatefulWidget {
  const MyFavoriteContacts({super.key});

  @override
  State<MyFavoriteContacts> createState() => _MyFavoriteContactsState();
}

class _MyFavoriteContactsState extends State<MyFavoriteContacts> {
  late ContactUserCubit cubit;

  @override
  Widget build(BuildContext context) {
    cubit = BlocProvider.of<ContactUserCubit>(context);
    cubit.queryFavoriteList();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "My Favorite",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: BlocBuilder<ContactUserCubit, ContactUserState>(
          builder: (context, state) {
            return _favoriteListPage();
          },
        ));
  }

  Widget _favoriteListPage() {
    return ListView.separated(
        itemBuilder: _listItems,
        padding: const EdgeInsets.symmetric(vertical: 10),
        separatorBuilder: (BuildContext context, int index) => const Divider(
              color: Colors.black,
            ),
        itemCount: cubit.state.favoriteUserList.length);
  }

  Widget _listItems(BuildContext context, int index) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          cubit.jumpToUpdateContact(context, true, index);
        },
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            Expanded(
                flex: 2,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          const AssetImage("assets/images/people.png"),
                      foregroundImage: FileImage(File(
                          cubit.state.favoriteUserList[index].imagePath ?? "")),
                    ),
                  ),
                )),
            Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Text(cubit.state.favoriteUserList[index].name.toString())
                  ],
                )),
          ],
        ));
  }
}
