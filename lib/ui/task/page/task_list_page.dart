import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/ui/components/pagination.dart';
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
        actions: [
          IconButton(
            onPressed: () => store.dispatch(OpenCreateTaskPageAction()),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) => _ViewModel(store),
        onInitialBuild: (viewModel) {
          viewModel.loadData();
        },
        builder: (context, viewModel) {
          return viewModel.isLoaded
              ? viewModel.currentPageTasks.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.currentPageTasks.length,
                            itemBuilder: (context, index) {
                              final task = viewModel.currentPageTasks[index];
                              return ListTile(
                                title: Text(task.title),
                                onTap: () => store
                                    .dispatch(OpenEditTaskPageAction(task)),
                              );
                            },
                            separatorBuilder: (_, __) => const Divider(
                              thickness: 0.5,
                              height: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Pagination(
                            current: viewModel.currentPage!,
                            total: viewModel.pagesTotal!,
                            isDataLoading: viewModel.isTasksLoading,
                            onPrevPressed: viewModel.onPrevPressed,
                            onNextPressed: viewModel.onNextPressed,
                          ),
                        ],
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
  final int? tasksTotal;
  final int? pagesTotal;
  final int? pageSize;
  final int? currentPage;
  final bool isTasksLoading;

  _ViewModel(this._store)
      : tasks = _store.state.taskState.tasks,
        tasksTotal = _store.state.taskState.tasksTotal,
        pagesTotal = _store.state.taskState.pagesTotal,
        pageSize = _store.state.taskState.pageSize,
        currentPage = _store.state.taskState.page,
        isTasksLoading = _store.state.taskState.isTasksLoading;

  bool get isLoaded => tasks != null;

  void loadData() {
    if (!isLoaded) {
      getTasks();
    }
  }

  void getTasks([int? page]) {
    page ??= currentPage ?? 1;
    if (!isLoaded || !tasks!.any((e) => e.page == page)) {
      _store.dispatch(GetTasksAction(
        page: page,
        pageSize: tasksPageSize,
        orderBy: tasksOrderBy,
      ));
    } else {
      _store.dispatch(UpdateTasksPageAction(page));
    }
  }

  void onPrevPressed() {
    getTasks(currentPage! - 1);
  }

  void onNextPressed() {
    getTasks(currentPage! + 1);
  }

  List<Task> get currentPageTasks =>
      tasks?.where((e) => e.page == currentPage).toList() ?? [];

  @override
  List<Object?> get props => [
        tasks,
        tasksTotal,
        pagesTotal,
        pageSize,
        currentPage,
        isTasksLoading,
      ];
}
