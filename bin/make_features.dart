import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';

import 'command.dart';
import 'package:dcli/dcli.dart' as dcli;

class MakeFeature extends Command {
  MakeFeature(
      {required String? projectName, required bool isCreate, String? outPut}) {
    this.createOrDeleteProject(
        name: projectName, isCreate: isCreate, outPut: outPut);
  }

  @override
  createOrDeleteProject({String? name, bool? isCreate, String? outPut}) {
    // TODO: implement createOrDeleteProject

    if (isCreate!) {
      runMason(name!, outPut);
    } else {
      _deleteProject(name!);
    }
  }

  runMason(String name, String? outPut) async {
    //
    print(dcli.green('Name of your features is: $name'));

    var _outPut = outPut ?? "./lib/featchers";

    try {

      "dart pub global deactivate mason_cli".run;
      "mason make my_feature featchers --name $name -o $_outPut".run;
    } on Exception catch (e) {
      // TODO

      printerr(e.toString());
    }
    _dependancyInjection(name);
  }

  _dependancyInjection(String name) {
    var _file = "./lib/core/dependencyInjection/app_dependency_injections.dart";

    var _data = dcli.read(_file);

    List<String> _splitedList = _data.toParagraph().split("}");

    String _writeData = "";

    _splitedList.forEach((element) {
      if (_splitedList.indexOf(element) == _splitedList.length - 1) {
        element.replaceAll("\n", "");
        element.replaceAll(" ", "");

        _writeData += element.replaceAll("}", "").replaceAll(" ", "") +
            "//function \n sl.registerLazySingleton(() => ${capitalize(name)}Functions()); \n";

        _writeData += element.replaceAll("}", "").replaceAll(" ", "") +
            "//DataSource \n sl.registerLazySingleton<${capitalize(name)}RemoteDataSource>(() => ${capitalize(name)}RemoteDataSourceImpl()); \n";

        _writeData += element.replaceAll("}", "").replaceAll(" ", "") +
            "//repository \n   sl.registerLazySingleton<${capitalize(name)}Repository>(() => ${capitalize(name)}RepositoryImpl(${name.toLowerCase()}RemoteDataSource: sl()));\n";

        _writeData += element.replaceAll("}", "").replaceAll(" ", "") +
            "//usecase \n   sl.registerLazySingleton<${capitalize(name)}UseCase>(() => ${capitalize(name)}UseCase(eRepository: sl()));\n }";
      } else {
        if (_splitedList.indexOf(element) == _splitedList.length - 2) {
          _writeData += element + " \n";
        } else {
          _writeData += element + " \n}";
        }
      }
    });

    String imports =
        ''' import '../../featchers/${name.toLowerCase()}/data/remoteDataSource/${name.toLowerCase()}_data_source.dart'; 
  import '../../featchers/${name.toLowerCase()}/data/respository/${name.toLowerCase()}_repository_impl.dart'; 
  import '../../featchers/${name.toLowerCase()}/domain/repository/${name.toLowerCase()}_repository.dart'; \n
  import '../../featchers/${name.toLowerCase()}/domain/useCase/${name.toLowerCase()}_use_case.dart'; \n
  import '../../featchers/${name.toLowerCase()}/presentation/functions/${name.toLowerCase()}_functions.dart'; \n  
  ''';

    _file.write(imports + _writeData);
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void _deleteProject(name) {
    try {
      "rm -rf ./lib/featchers/$name".run;
      _removeDependancyInjection(name);
    } catch (e) {
      print(dcli.red('Project $name not found for ${e.toString()}'));
    }
  }

  _removeDependancyInjection(String name) {
    var _file = "./lib/core/dependencyInjection/app_dependency_injections.dart";

    String writeFile = '';

    // new File(_file)
    //     .openRead()
    //     .map(utf8.decode)
    //     .transform(new )
    //     .forEach((l) {
    //   bool _isContain = _replaceStringOperation(l.replaceAll(" ", ""), name);
    //
    //   print("Line : ${l}");
    //
    //   if (_isContain == false) {
    //     writeFile = writeFile + l + "\n";
    //   } else {
    //     writeFile += "\n";
    //   }
    // }).then((value) {
    //   print(dcli.green(writeFile));
    // });

    var _data;

    try {
      _data = dcli.read(_file);
    } catch (error) {
      // TODO

      print("Error : ${error.toString()}");
    }

    List<String> _splitedList = _data.toParagraph().split("}");

    for (var i = 0; i < _splitedList.length; i++) {
      print(
          "Index of : ${i} _replaceStringOperation(_splitedList[i], name); ::: ${_replaceStringOperation(_splitedList[i], name)}");

      if (i == _splitedList.length - 1) {
        writeFile += "\n";
      } else {
        writeFile += _replaceStringOperation(_splitedList[i], name) + "}";
      }

      //   _splitedList[i].append("}");
    }

    _file.write(writeFile);
    print(dcli.green('Project $name deleted'));
  }

  String _replaceStringOperation(String element, String name) {
    String _write = element;
    if (element.contains(
        "import '../../featchers/${name.toLowerCase()}/data/remoteDataSource/${name.toLowerCase()}_data_source.dart';")) {
      print("Containing  : ");

      try {
        _write = element.replaceAll(
            "import '../../featchers/${name.toLowerCase()}/data/remoteDataSource/${name.toLowerCase()}_data_source.dart';",
            "");

        print("Replaced  : ${_write}");
      } catch (err) {
        print("Error : ${err.toString()}");
      }
    }

    if (_write.contains(
        "import '../../featchers/${name.toLowerCase()}/domain/repository/${name.toLowerCase()}_repository.dart';")) {
      _write = _write.replaceAll(
          "import '../../featchers/${name.toLowerCase()}/domain/repository/${name.toLowerCase()}_repository.dart';",
          "");
    }

    if (_write.contains(
        "import '../../featchers/${name.toLowerCase()}/data/respository/${name.toLowerCase()}_repository_impl.dart';")) {
      print("Containing  : ");

      try {
        _write = _write.replaceAll(
            "import '../../featchers/${name.toLowerCase()}/data/respository/${name.toLowerCase()}_repository_impl.dart';",
            "");

        print("Replaced  : ${_write}");
      } catch (err) {
        print("Error : ${err.toString()}");
      }
    }
    if (_write.contains(
        "import '../../featchers/${name.toLowerCase()}/presentation/functions/${name.toLowerCase()}_functions.dart';")) {
      print("Containing  : ");

      try {
        _write = _write.replaceAll(
            "import '../../featchers/${name.toLowerCase()}/presentation/functions/${name.toLowerCase()}_functions.dart';",
            "");

        print("Replaced  : ${_write}");
      } catch (err) {
        print("Error : ${err.toString()}");
      }
    }
    if (_write.contains(
        "import '../../featchers/${name.toLowerCase()}/domain/useCase/${name.toLowerCase()}_use_case.dart';")) {
      print("Containing  : ");

      try {
        _write = _write.replaceAll(
            "import '../../featchers/${name.toLowerCase()}/domain/useCase/${name.toLowerCase()}_use_case.dart';",
            "");

        print("Replaced  : ${_write}");
      } catch (err) {
        print("Error : ${err.toString()}");
      }
    }

    ///
    if (_write.contains(
        "sl.registerLazySingleton(() => ${capitalize(name)}Functions());")) {
      _write = _write.replaceAll(
          "sl.registerLazySingleton(() => ${capitalize(name)}Functions());",
          "");
    }

    _write.replaceAll("\n", "");
    if (_write.replaceAll("\n", "").contains(
            "sl.registerLazySingleton<${capitalize(name)}RemoteDataSource>(() => ${capitalize(name)}RemoteDataSourceImpl());") ||
        _write.contains(
            "sl.registerLazySingleton<${capitalize(name)}RemoteDataSource>(\n() => ${capitalize(name)}RemoteDataSourceImpl());")) {
      print("Contain data source");

      _write = _write.replaceAll(
          "sl.registerLazySingleton<${capitalize(name)}RemoteDataSource>(() => ${capitalize(name)}RemoteDataSourceImpl());",
          "");

      _write = _write.replaceAll(
          "sl.registerLazySingleton<${capitalize(name)}RemoteDataSource>(\n() => ${capitalize(name)}RemoteDataSourceImpl());",
          "");
    }
    if (_write.contains(
            "sl.registerLazySingleton<${capitalize(name)}Repository>(() => ${capitalize(name)}RepositoryImpl(${name.toLowerCase()}RemoteDataSource: sl()));") ||
        _write.contains(
            "sl.registerLazySingleton<${capitalize(name)}Repository>(\n() => ${capitalize(name)}RepositoryImpl(${name.toLowerCase()}RemoteDataSource: sl()));")) {
      _write = _write.replaceAll(
          "sl.registerLazySingleton<${capitalize(name)}Repository>(() => ${capitalize(name)}RepositoryImpl(${name.toLowerCase()}RemoteDataSource: sl()));",
          "");
      _write = _write.replaceAll(
          "sl.registerLazySingleton<${capitalize(name)}Repository>(\n() => ${capitalize(name)}RepositoryImpl(${name.toLowerCase()}RemoteDataSource: sl()));",
          "");
    }
    if (_write.contains(
        "sl.registerLazySingleton<${capitalize(name)}UseCase>(() => ${capitalize(name)}UseCase(eRepository: sl()));")) {
      _write = _write.replaceAll(
          "sl.registerLazySingleton<${capitalize(name)}UseCase>(() => ${capitalize(name)}UseCase(eRepository: sl()));",
          "");
    }

    print("Write : ${_write}");

    return _write;
  }
}

/*
*
* _data = _data.replaceAll(
        "import '../../featchers/${name.toLowerCase()}/data/remoteDataSource/${name.toLowerCase()}_data_source.dart';",
        "");

    print(
        "Is contain : ${_data.contains("sl.registerLazySingleton(() => ${capitalize(name)}Functions());")}");

    _data.replaceAll(
        "sl.registerLazySingleton(() => ${capitalize(name)}Functions());", "");
    _data.replaceAll(
        "sl.registerLazySingleton<${capitalize(name)}RemoteDataSource>(() => ${capitalize(name)}RemoteDataSourceImpl());",
        "");

    _data.replaceAll(
        "sl.registerLazySingleton<${capitalize(name)}Repository>(() => ${capitalize(name)}RepositoryImpl(${name.toLowerCase()}RemoteDataSource: sl()));",
        "");

    _data.replaceAll(
        "sl.registerLazySingleton<${capitalize(name)}UseCase>(() => ${capitalize(name)}UseCase(eRepository: sl()));",
        "");
    _data.replaceAll(
        "import '../../featchers/${name.toLowerCase()}/data/remoteDataSource/${name.toLowerCase()}_data_source.dart';"
            .toString(),
        "");
    _data.replaceAll(
        "import '../../featchers/${name.toLowerCase()}/data/respository/${name.toLowerCase()}_repository_impl.dart';",
        "");
    _data.replaceAll(
        "import '../../featchers/${name.toLowerCase()}/domain/useCase/${name.toLowerCase()}_use_case.dart';",
        "");
    _data.replaceAll(
        "import '../../featchers/${name.toLowerCase()}/presentation/functions/${name.toLowerCase()}_functions.dart';",
        "");
*
* */
