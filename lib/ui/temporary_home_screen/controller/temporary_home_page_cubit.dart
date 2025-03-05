import 'package:ayeayecaptain_mobile/ui/temporary_home_screen/controller/temporary_home_page_states.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemporaryHomePageCubit extends Cubit<TemporaryHomePageStates> {
  TemporaryHomePageCubit() : super(TemporaryHomePageInitialState());

  Future<void> fetchHomePage() async {
    try {
      final previousState = state;
      if (previousState is FetchHomePageState) {
        emit(FetchHomePageState(status: StateStatus.success, response: previousState.response));
      } else {
        emit(FetchHomePageState(status: StateStatus.loading));
      }
      final Dio dio = Dio();
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      final String? backend = sharedPreferences.getString("backend");
      final String? token = sharedPreferences.getString("token");
      final Response response = await dio.get(
        '$backend/api/sideapp/home',
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Token $token'}),
      );
      emit(FetchHomePageState(status: StateStatus.success, response: response.data));
    } catch (e) {
      emit(FetchHomePageState(status: StateStatus.error));
    }
  }

  Future<void> clickMeAction({required int id}) async {
    try {
      emit(HomeClickMeActionState(status: StateStatus.loading));

      final Dio dio = Dio();
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      final String? backend = sharedPreferences.getString("backend");
      final String? token = sharedPreferences.getString("token");
      await dio.post(
        '$backend/api/sideapp/home',
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Token $token'}),
        data: FormData.fromMap({'beacon': id}),
      );

      emit(HomeClickMeActionState(status: StateStatus.success, message: "Got it"));
    } catch (e) {
      emit(HomeClickMeActionState(status: StateStatus.error, message: e.toString()));
    }
  }

  Future<void> actionButton({required String id}) async {
    try {
      emit(HomeActionButtonState(status: StateStatus.loading));
      final Dio dio = Dio();
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      final String? backend = sharedPreferences.getString("backend");
      final String? token = sharedPreferences.getString("token");
      await dio.post(
        '$backend/api/sideapp/home',
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Token $token'}),
        data: FormData.fromMap({'quick_action': id}),
      );
      emit(HomeActionButtonState(status: StateStatus.success, message: "Got it"));
    } catch (e) {
      emit(HomeActionButtonState(status: StateStatus.error, message: e.toString()));
    }
  }
}
