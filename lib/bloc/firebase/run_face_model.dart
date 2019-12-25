import 'dart:convert';
import 'dart:io';

import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

Future<List<double>> runFaceModel(String imagePath, Rect box) async {
  img.Image image = img.decodeImage(await File(imagePath).readAsBytes());

  final croppedImage = img.copyCrop(
    image,
    box.right.round(),
    box.top.round(),
    box.width.round(),
    box.height.round(),
  );

  final body = {"image": base64.encode(img.encodePng(croppedImage))};

  final res = await http.post(
    faceFunction,
    body: jsonEncode(body),
    headers: {"content-type": "application/json"},
    encoding: Encoding.getByName('utf-8'),
  );

  return List<double>.from(jsonDecode(res.body)['result']);
}
