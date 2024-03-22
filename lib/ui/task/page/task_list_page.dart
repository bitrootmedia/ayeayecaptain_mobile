import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = di<Store<AppState>>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => store.dispatch(ClosePageAction()),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) => _ViewModel(store),
        onInitialBuild: (viewModel) {
          viewModel.loadData();
        },
        builder: (context, viewModel) {
          return viewModel.isLoaded
              ? viewModel.tasks!.isNotEmpty
                  ? ListView.separated(
                      itemCount: viewModel.tasks!.length,
                      itemBuilder: (context, index) {
                        final task = viewModel.tasks![index];
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(task.title),
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(
                        thickness: 0.5,
                        height: 0.5,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'Tasks not found',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final Store<AppState> _store;
  final List<Task>? tasks;

  _ViewModel(this._store) : tasks = _store.state.taskState.tasks;

  bool get isLoaded => tasks != null;

  void loadData() {
    if (!isLoaded) {
      _store.dispatch(GetTasksAction(_store.state.profileState.selected!));
    }
  }

  @override
  List<Object?> get props => [tasks];
}
