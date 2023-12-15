import '../constants.dart';

class EventObject {
  int id;
  Object? object;

  EventObject({this.id = EventConstants.NO_INTERNET_CONNECTION, this.object});
}
