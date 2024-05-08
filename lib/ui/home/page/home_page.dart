import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/profile/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = di<Store<AppState>>();

  @override
  void initState() {
    store.dispatch(GetProfilesAction());
    handleAppLifecycleState();
    super.initState();
  }

  @override
  void dispose() {
    SystemChannels.lifecycle.setMessageHandler(null);
    super.dispose();
  }

  Widget getMenuTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
      ),
    );
  }

  Widget get divider => const Divider(
        thickness: 0.5,
        height: 0.5,
      );

  void handleAppLifecycleState() {
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (message == AppLifecycleState.resumed.toString()) {
        store.dispatch(GetTasksAction(
          page: store.state.taskState.page,
          pageSize: store.state.taskState.pageSize,
          orderBy: tasksOrderBy,
          shouldReset: true,
        ));
      }
      return message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aye-aye Captain!'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => store.dispatch(OpenProfileListPageAction()),
            icon: const Icon(Icons.manage_accounts_outlined),
          ),
        ],
      ),
      body: ListView(
        children: [
          getMenuTile(
            title: 'Projects',
            onTap: () => store.dispatch(OpenProjectListPageAction()),
          ),
          divider,
          getMenuTile(
            title: 'Tasks',
            onTap: () => store.dispatch(OpenTaskListPageAction()),
          ),
        ],
      ),
    );
  }
}
