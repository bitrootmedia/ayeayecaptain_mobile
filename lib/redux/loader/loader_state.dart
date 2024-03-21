class LoaderState {
  final bool isLoading;

  LoaderState({
    this.isLoading = false,
  });

  LoaderState.initial() : isLoading = false;

  LoaderState copyWith({
    bool? isLoading,
  }) =>
      LoaderState(
        isLoading: isLoading ?? this.isLoading,
      );
}
