import '../../bloc_helpers/bloc_event_state.dart';
import './application_initialization_event.dart';
import './application_initialization_state.dart';

class ApplicationInitializationBloc extends BlocEventStateBase<
    ApplicationInitializationEvent, ApplicationInitializationState> {
  ApplicationInitializationBloc()
      : super(
          initialState: ApplicationInitializationState(),
        );

  @override
  Stream<ApplicationInitializationState> eventHandler(
      ApplicationInitializationEvent event,
      ApplicationInitializationState state) async* {
    if (event.applicationInitializationEventType ==
        ApplicationInitializationEventType.initialized) {
      yield ApplicationInitializationState.initializing();
      await Future.delayed(Duration(milliseconds: 2500));
      yield ApplicationInitializationState.initialized();
    }
  }
}
