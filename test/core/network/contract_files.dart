import 'dart:convert';
import 'dart:io';

const String contractsDir = 'contracts';

Object? readContract(String path) =>
    jsonDecode(File('$contractsDir/$path').readAsStringSync());

List<Map<String, dynamic>> errorCodeRows() =>
    ((readContract('error-codes.json')! as Map)['codes'] as List)
        .cast<Map<String, dynamic>>();

List<File> fixtureFiles(String folder) => Directory(
  '$contractsDir/fixtures/$folder',
).listSync().whereType<File>().toList();

Map<String, dynamic> readFixture(File file) =>
    jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

Map<String, dynamic> readNamedFixture(String folder, String name) =>
    readFixture(
      fixtureFiles(folder).firstWhere((file) => file.path.contains(name)),
    );
