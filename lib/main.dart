import 'dart:io';

import 'package:contact/MyFavoriteContacts.dart';
import 'package:contact/add_new_contact_user/view.dart';
import 'package:contact/contact_user/cubit.dart';
import 'package:contact/contact_user/state.dart';
import 'package:contact/update_contact_user/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ContactUserCubit>(
            create: (BuildContext context) => ContactUserCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Contact List',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Contact List'),
          routes: <String, WidgetBuilder>{
            'myFavorite': (BuildContext context) => const MyFavoriteContacts(),
            'addNewContactUser': (BuildContext context) =>
                const AddNewContactUserPage(),
            'updateContactUser': (BuildContext context) =>
                const UpdateContactUserPage()
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ContactUserCubit cubit;

  @override
  void initState() {
    cubit = BlocProvider.of<ContactUserCubit>(context);
    cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // cubit = context.read<ContactUserCubit>();
    return Scaffold(
      drawer: Drawer(
          child: Column(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
          ListTile(
              title: const Text("Contact list"),
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.people, color: Colors.black),
              ),
              onTap: () {
                cubit.jumpToContactsList(context);
              }),
          const Divider(),
          ListTile(
              title: const Text("Favorite contacts"),
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.star_border, color: Colors.black),
              ),
              onTap: () {
                cubit.jumpToMyFavorite(context);
              }),
          const Divider(),
          ListTile(
            title: const Text("Add new contact"),
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.add, color: Colors.black),
            ),
            onTap: () {
              cubit.jumpToAddNewContact(context, true);
            },
          )
        ],
      )),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocBuilder<ContactUserCubit, ContactUserState>(
        builder: (context, state) {
          return _contactListPage();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          cubit.jumpToAddNewContact(context, false);
        },
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _contactListPage() {
    return ListView.separated(
        itemBuilder: _listItems,
        padding: const EdgeInsets.symmetric(vertical: 10),
        separatorBuilder: (BuildContext context, int index) => const Divider(
              color: Colors.black,
            ),
        itemCount: cubit.state.contactUserList.length);
  }

  Widget _listItems(BuildContext context, int index) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          cubit.jumpToUpdateContact(context, false, index);
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
                          cubit.state.contactUserList[index].imagePath ?? "")),
                    ),
                  ),
                )),
            Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Text(cubit.state.contactUserList[index].name.toString())
                  ],
                )),
          ],
        ));
  }
}
