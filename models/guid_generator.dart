import 'package:uuid/uuid.dart';

class Guid {
  static String newGuid() {
    const uuid = Uuid();
    return uuid.v4();
  }
}
