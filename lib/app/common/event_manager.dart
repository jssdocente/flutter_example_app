
import 'dart:async';

enum EventChannel { Notificacion, Autentication, JournalStart,JournalEnd,ChangeStateAdded, ChangeStateSended}

class EventManager {

  final Map<EventChannel, StreamController> _mapChannelControllers;

  EventManager._(this._mapChannelControllers);

  factory EventManager.create() {
    return EventManager._(new Map<EventChannel, StreamController>());
  }

  void sendEvent(EventChannel channel, AppEvent event) {
    if (!_mapChannelControllers.containsKey(channel)) {
      _mapChannelControllers.putIfAbsent(channel, () => new StreamController<AppEvent>.broadcast());
    }

    _mapChannelControllers[channel].add(event);
  }

  Stream<AppEvent> subscribeToChannel(EventChannel channel) {
    if (!_mapChannelControllers.containsKey(channel)) {
      _mapChannelControllers.putIfAbsent(channel, () => new StreamController<AppEvent>.broadcast());
    }
    return _mapChannelControllers[channel].stream;
  }

  void closeChannel(EventChannel channel) {
    if (_mapChannelControllers.containsKey(channel)) {
      _mapChannelControllers[channel].close();
      _mapChannelControllers.remove(channel);
    }
  }

}

abstract class AppEvent {

}

class PushNotificationReceivedEvent extends AppEvent {}
class PushNotificationRefreshEvent extends AppEvent {}
class PushNotificationReadedEvent extends AppEvent {}

class AuthLoggedEvent extends AppEvent {}
class AuthLogoutEvent extends AppEvent {}

class JournalStartEvent extends AppEvent {}
class JournalEndEvent extends AppEvent {}