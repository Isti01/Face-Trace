import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<String> downloadImage(String initialPhoto) async {
  if (initialPhoto == null) return null;
  try {
    final pathHash = md5.convert(utf8.encode(initialPhoto)).toString();
    final fileName = Uri.dataFromString(initialPhoto).path.split('/').last;
    final tempFolder = await getTemporaryDirectory();
    final imageFile = File(path.join(tempFolder.path, pathHash, fileName));

    if (await imageFile.exists()) return imageFile.path;

    final bytes = await getImage(initialPhoto);

    final file = await imageFile.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);

    final facePhotoPath = file.path;

    return facePhotoPath;
  } catch (e, s) {
    print([e, s]);
  }

  return null;
}

Future<List<int>> getImage(String url) async =>
    (await http.get(url)).bodyBytes.toList();
