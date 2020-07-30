import '../../bloc_helpers/bloc_event_state.dart';
import './application_initialization_event.dart';
import './application_initialization_state.dart';

class ApplicationInitializationBloc extends BlocEventStateBase<
    ApplicationInitializationEvent, ApplicationInitializationState> {
  ApplicationInitializationBloc()
      : super(
          initialState: ApplicationInitializationState.notInitialized(),
        );

  @override
  Stream<ApplicationInitializationState> eventHandler(
      ApplicationInitializationEvent event,
      ApplicationInitializationState currentState) async* {
    if (!currentState.isInitialized) {
      yield ApplicationInitializationState.notInitialized();
    }

    if (event.type == ApplicationInitializationEventType.start) {
      for (int progress = 0; progress <= 100; progress += 10) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (progress >= 60) {
          yield ApplicationInitializationState.progressing(progress);
        }
      }
    }

    if (event.type == ApplicationInitializationEventType.initialized) {
      yield ApplicationInitializationState.initialized();
    }
  }
}
