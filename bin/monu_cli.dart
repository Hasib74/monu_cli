import 'dart:io';

import 'package:dcli/dcli.dart' as dcli;
import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

import 'make_features.dart';
import 'make_project.dart';
import 'package:mason/mason.dart' as mason;

main(List<String> arguments) async {
  // runMason();

  //_activeMason();

  var parser = ArgParser();

  parser.addOption('name', abbr: 'n', help: 'Name of the project or feature');
  parser.addOption('output', abbr: 'o', help: 'Path of the project folder');
  parser.addCommand("update");

  _projectOptions(parser);

  _featureOptions(parser);

  _help(parser);

  _result(parser, arguments);
}

void _activeMason() async {


  var activateProcess = await Process.run('pub', ['global', 'activate', 'mason']);
  if (activateProcess.exitCode != 0) {
    print('Failed to activate Mason: ${activateProcess.stderr}');
    return;
  }



  // "dart pub global activate mason_cli".run;
  // "mason add -g my_app --git-url https://github.com/Hasib74/cli_bricks.git --git-path bricks/my_app"
  //     .run;
  // "mason add -g my_feature --git-url https://github.com/Hasib74/cli_bricks.git --git-path bricks/my_feature"
  //     .run;
}

update(ArgParser parser) {
  "mason update -g my_app".run;
  "mason update -g my_features".run;
}

void _help(dcli.ArgParser parser) {
  parser.addFlag("help",
      abbr: 'h', negatable: false, help: 'Displays this help message.');
}

void _projectOptions(dcli.ArgParser parser) {
  parser.addOption(
    'project',
    abbr: 'p',
    help: 'Create a new project',
    allowed: ['create', 'delete'],
    allowedHelp: {
      'create': 'Create a new project',
      'delete': 'Delete your project',
    },
  );
}

void _featureOptions(dcli.ArgParser parser) {
  parser
      .addOption('feature', abbr: 'f', help: 'Create a new feature', allowed: [
    'make',
    'delete'
  ], allowedHelp: {
    'make': 'Create a new feature',
    'delete': 'Delete a feature',
  });
}

void _result(dcli.ArgParser parser, List<String> arguments) {
  var results = parser.parse(arguments);

  // if (parser.commands["update"] != null) {
  //   update(parser);
  // }

  if (results["feature"] != null) {
    var _name = results["name"];
    var _output = results["output"];
    bool isMake = results["feature"] == "make";
    if (isMake) {
      print(dcli.green('Are you sure you want to create this feature: $_name'));
      var _answer = dcli.ask("y/n: ", required: true, validator: Ask.required);

      if (_answer == "y") {
        MakeFeature(projectName: _name, isCreate: true, outPut: _output);
      } else {
        exit(0);
      }
    } else {
      print(dcli.green('Are you sure you want to delete this feature: $_name'));
      var _answer = dcli.ask("y/n: ", required: true, validator: Ask.required);

      if (_answer == "y") {
        MakeFeature(projectName: _name, isCreate: false);
      } else {
        exit(0);
      }
    }
  } else if (results["project"] != null) {
    var _name = results["name"];
    var _output = results["output"];
    bool isCreate = results["project"] == "create";

    if (isCreate) {
      print(dcli.green('Are you sure you want to create this project: $_name'));
      var _answer = dcli.ask("y/n: ", required: true, validator: Ask.required);

      if (_answer == "y") {
        MakeProject(name: _name, isCreate: true, outPut: _output);
      } else {
        exit(0);
      }
    }
  }

  if (results['help'] == true) {
    print(parser.usage);
    exit(0);
  }
}
