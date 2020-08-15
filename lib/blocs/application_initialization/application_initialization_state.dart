import '../../bloc_helpers/bloc_event_state.dart';

class ApplicationInitializationState extends BlocState {
  ApplicationInitializationState({
    this.isInitialized: false,
    this.isInitializing: false,
  });

  final bool isInitialized;
  final bool isInitializing;

  factory ApplicationInitializationState.initializing() {
    return ApplicationInitializationState(
      isInitializing: true,
    );
  }

  factory ApplicationInitializationState.initialized() {
    return ApplicationInitializationState(
      isInitialized: true,
    );
  }
}
