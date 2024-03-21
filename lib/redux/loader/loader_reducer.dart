import 'package:ayeayecaptain_mobile/redux/loader/actions.dart';
import 'package:ayeayecaptain_mobile/redux/loader/loader_state.dart';
import 'package:redux/redux.dart';

class LoaderReducer extends ReducerClass<LoaderState> {
  @override
  LoaderState call(LoaderState state, action) => combineReducers<LoaderState>([
        TypedReducer(_showLoader).call,
        TypedReducer(_hideLoader).call,
      ])(state, action);

  LoaderState _showLoader(
    LoaderState state,
    ShowLoaderAction action,
  ) =>
      state.copyWith(
        isLoading: true,
      );

  LoaderState _hideLoader(
    LoaderState state,
    HideLoaderAction action,
  ) =>
      state.copyWith(isLoading: false);
}
