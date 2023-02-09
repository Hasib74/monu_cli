import 'package:dcli/dcli.dart';

abstract class Command {
  createOrDeleteProject({String? name, bool? isCreate}) {
    print("name: $name");
    print("isCreate: $isCreate");

  }

  createProject({String? name}) {
    print("name: $name");
  }
}
