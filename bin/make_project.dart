import 'package:dcli/dcli.dart';
import 'command.dart';
import 'dcli.dart';

class MakeProject extends Command {
  MakeProject({String? name}) {
    super.createProject(name: name);
  }

  @override
  createProject({String? name}) {
    // TODO: implement createProject
    print("name: $name");
  }
}
