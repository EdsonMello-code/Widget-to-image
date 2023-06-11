import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

mixin ImageMixin {
  Future<String> takePicture(GlobalKey genKey) async {
    final imageInMemory = await generateImageInMemory(genKey);
    final directoryPath = await saveImageInStorage(imageInMemory);
    if (directoryPath == null) {
      throw Exception('Error ao salvar imagem');
    }
    return directoryPath;
  }

  Future<String?> getDownloadsFolder() async {
    final externalStorageDirs = await getExternalStorageDirectories() ?? [];

    if (externalStorageDirs.isEmpty) return null;
    return externalStorageDirs.first.path;
  }

  Future<Uint8List> generateImageInMemory(GlobalKey genKey) async {
    final RenderRepaintBoundary boundary =
        genKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<String?> saveImageInStorage(Uint8List imageInMemory) async {
    final downloadDirectory = await getDownloadsFolder();
    if (downloadDirectory == null) {
      return null;
    }

    File imgFile =
        File('$downloadDirectory/${DateTime.now().microsecondsSinceEpoch}.png');

    await imgFile.writeAsBytes(imageInMemory);
    return downloadDirectory;
  }
}
