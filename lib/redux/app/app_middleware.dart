import 'package:ayeayecaptain_mobile/domain/profile/interface/profile_repository.dart';
import 'package:ayeayecaptain_mobile/redux/app/actions.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:redux_epics/redux_epics.dart';

class AppMiddleware extends EpicMiddleware<AppState> {
  AppMiddleware(
    ProfileRepository repository,
  ) : super(
          combineEpics(
            [
              _getProfiles(repository),
              _saveProfiles(repository),
            ],
          ),
        );

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
            }
          },
        ),
      ).call;
}
