import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/project/actions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = di<Store<AppState>>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
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
              ? viewModel.projects!.isNotEmpty
                  ? ListView.separated(
                      itemCount: viewModel.projects!.length,
                      itemBuilder: (context, index) {
                        final project = viewModel.projects![index];
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(project.title),
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
                          'Projects not found',
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
  final List<Project>? projects;

  _ViewModel(this._store) : projects = _store.state.projectState.projects;

  bool get isLoaded => projects != null;

  void loadData() {
    if (!isLoaded) {
      _store.dispatch(GetProjectsAction(_store.state.profileState.selected!));
    }
  }

  @override
  List<Object?> get props => [projects];
}
