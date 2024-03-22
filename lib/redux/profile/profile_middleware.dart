import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/profile/interface/profile_repository.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/loader/actions.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/profile/actions.dart';
import 'package:ayeayecaptain_mobile/redux/project/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:redux_epics/redux_epics.dart';

class ProfileMiddleware extends EpicMiddleware<AppState> {
  ProfileMiddleware(
    ProfileRepository repository,
  ) : super(
          combineEpics(
            [
              _login(repository),
              _getProfiles(repository),
              _saveProfiles(repository),
            ],
          ),
        );

  static Epic<AppState> _login(
    ProfileRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<LoginAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            yield ShowLoaderAction();
            final request = await repository.login(action.profile);

            if (request.wasSuccessful) {
              final profiles =
                  List<Profile>.from(store.state.profileState.profiles ?? [])
                      .map((e) => e.copyWith(isSelected: false))
                      .toList();
              final newProfile =
                  action.profile.copyWith(token: request.result!);
              yield SaveProfilesAction([...profiles, newProfile]);
            }
            yield HideLoaderAction();
          },
        ),
      ).call;

  static Epic<AppState> _getProfiles(
    ProfileRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<GetProfilesAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            final request = await repository.getProfiles();

            if (request.wasSuccessful) {
              yield UpdateProfilesAction(request.result!);
            }
          },
        ),
      ).call;

  static Epic<AppState> _saveProfiles(
    ProfileRepository repository,
  ) =>
      TypedEpic(
        (
          Stream<SaveProfilesAction> actions,
          EpicStore<AppState> store,
        ) =>
            actions.asyncExpand(
          (action) async* {
            final request = await repository.saveProfiles(action.profiles);

            if (request.wasSuccessful) {
              yield GetProfilesAction();

              // Reset app content
              yield ResetProjectsAction();
              yield ResetTasksAction();

              yield OpenHomePageAction();
            }
          },
        ),
      ).call;
}
