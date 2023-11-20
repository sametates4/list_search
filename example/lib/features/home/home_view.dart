import 'package:flutter/material.dart';
import 'package:list_search/list_search.dart';

import '../../core/model/user_model.dart';
import '../../core/service/network_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final service = NetworkService();
  late List<UserModel> userList;
  bool initComplete = false;

  @override
  void initState() {
    setUserData();
    super.initState();
  }

  Future<void> setUserData() async {
    userList = await service.fetchUser() ?? [];
    initComplete = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SearchList example')),
      body: initComplete
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchList<UserModel>(
            search: (value) => userList.where((user) => user.name!.toLowerCase().contains(value)).toList(),
            list: userList,
            builder: (value, index) {
              return ListTile(
                title: Text(value.name.toString()),
                subtitle: Text(value.email.toString()),
              );
            }
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}