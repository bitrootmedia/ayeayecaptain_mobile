import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/profile/actions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ProfileListPage extends StatelessWidget {
  const ProfileListPage({super.key});

  void _selectProfile(Profile profile) {
    final store = di<Store<AppState>>();
    final profiles = List<Profile>.from(store.state.profileState.profiles!);
    store.dispatch(
      SaveProfilesAction(
        profiles.map((e) => e.copyWith(isSelected: e == profile)).toList(),
      ),
    );
  }

  Widget getProfileTile(Profile profile) {
    return ListTile(
      onTap: () => _selectProfile(profile),
      title: Text(profile.name),
      subtitle: Text(profile.backendUrl),
      trailing: profile.isSelected
          ? const Icon(
              Icons.check,
              color: seedColor,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = di<Store<AppState>>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profiles'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: store.state.navigationState.previousRoutes.isNotEmpty
            ? IconButton(
                onPressed: () => store.dispatch(ClosePageAction()),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              )
            : null,
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
        builder: (context, viewModel) {
          return ListView.separated(
            itemCount: viewModel.profiles!.length,
            itemBuilder: (context, index) {
              final profile = viewModel.profiles![index];
              return getProfileTile(profile);
            },
            separatorBuilder: (_, __) => const Divider(
              thickness: 0.5,
              height: 0.5,
            ),
          );
        },
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final List<Profile>? profiles;

  _ViewModel(Store<AppState> store)
      : profiles = store.state.profileState.profiles;

  @override
  List<Object?> get props => [profiles];
}
