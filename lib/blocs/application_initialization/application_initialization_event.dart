import '../../bloc_helpers/bloc_event_state.dart';

class ApplicationInitializationEvent extends BlocEvent {
  ApplicationInitializationEventType applicationInitializationEventType;
  ApplicationInitializationEvent(
      {this.applicationInitializationEventType:
          ApplicationInitializationEventType.start});
}

enum ApplicationInitializationEventType {
  start,
  initialized,
}
