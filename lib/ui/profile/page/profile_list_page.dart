import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/redux/app/actions.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ProfileListPage extends StatelessWidget {
  const ProfileListPage({super.key});

  void _selectProfile(Profile profile) {
    final store = di<Store<AppState>>();
    final profiles = List<Profile>.from(store.state.profiles!);
    store.dispatch(
      SaveProfilesAction(
        profiles.map((e) => e.copyWith(isSelected: e == profile)).toList(),
      ),
    );
  }

  Widget getProfileTile(Profile profile) {
    return GestureDetector(
      onTap: () => _selectProfile(profile),
      child: ListTile(
        title: Text(profile.name),
        subtitle: Text(profile.backendUrl),
        trailing: profile.isSelected
            ? const Icon(
                Icons.check,
                color: seedColor,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = di<Store<AppState>>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profiles'),
        actions: [
          IconButton(
            onPressed: () => store.dispatch(OpenCreateProfilePageAction()),
            icon: const Icon(Icons.add),
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
              ? viewModel.profiles!.isNotEmpty
                  ? ListView.separated(
                      itemCount: viewModel.profiles!.length,
                      itemBuilder: (context, index) {
                        final profile = viewModel.profiles![index];
                        return getProfileTile(profile);
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
                          'You don\'t have any profiles yet.\nTap + button to create a profile.',
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
  final List<Profile>? profiles;

  _ViewModel(this._store) : profiles = _store.state.profiles;

  bool get isLoaded => profiles != null;

  void loadData() {
    _store.dispatch(GetProfilesAction());
  }

  @override
  List<Object?> get props => [profiles];
}
