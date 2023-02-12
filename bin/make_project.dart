import 'package:dcli/dcli.dart';
import 'command.dart';
import 'dcli.dart';

class MakeProject extends Command {
  MakeProject({String? name, String? outPut, bool? isCreate}) {
    this.createProject(name: name, output: outPut, isCreate: isCreate);
  }

  @override
  createProject({String? name, String? output, bool? isCreate}) {
    // TODO: implement createProject

    if (isCreate == true) {
      "mason make my_app --name $name -o $output".run;
    } else {
      try {
        "rm -rf ${output}/$name".run;
      } catch (err) {
        printerr("Can not find path: ${output} ");
      }
    }
  }
}
