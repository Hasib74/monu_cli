import 'dart:io';

import 'package:dcli/dcli.dart' as dcli;
import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

import 'make_features.dart';
import 'make_project.dart';

main(List<String> arguments) async {
  // runMason();

  var parser = ArgParser();

  _makeProject(parser);

  _feature(parser);

  _help(parser);

  _result(parser, arguments);
}

void _help(dcli.ArgParser parser) {
  parser.addFlag("help",
      abbr: 'h', negatable: false, help: 'Displays this help message.');
}

void _makeProject(dcli.ArgParser parser) {
  parser
      .addOption('project', abbr: 'f', help: 'Create a new project', allowed: [
    'create',
    'delete'
  ], allowedHelp: {
    'create': 'Create a new project',
    'delete': 'Delete your project',
  });

  parser.addOption('name', abbr: 'n', help: 'Name of the project');

  parser.addOption('output', abbr: 'o', help: 'Path of the project folder');
}

void _feature(dcli.ArgParser parser) {
  parser
      .addOption('feature', abbr: 'f', help: 'Create a new feature', allowed: [
    'make',
    'delete'
  ], allowedHelp: {
    'make': 'Create a new feature',
    'delete': 'Delete a feature',
  });

  parser.addOption('name', abbr: 'n', help: 'Name of the feature');

  parser.addOption('output', abbr: 'o', help: 'Path of the feature');

  // parser.addFlag("feature",
  //     abbr: 'f', negatable: false, help: 'Create a new feature');
}

void _result(dcli.ArgParser parser, List<String> arguments) {
  var results = parser.parse(arguments);

  if (results["feature"] != null) {
    var _name = results["name"];
    var _output = results["output"];
    bool isMake = results["feature"] == "make";
    if (isMake) {
      print(dcli.green('Are you sure you want to create this feature: $_name'));
      var _answer = dcli.ask("y/n: ", required: true, validator: Ask.required);

      if (_answer == "y") {
        MakeFeature(projectName: _name, isCreate: true);
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
