// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path/path.dart' as path;
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir =
        kIsWeb ? path.current : await getApplicationDocumentsDirectory();
    final file = File(path.join(dir.toString(), name));

    if (kIsWeb)
      _saveDocumentWeb(bytes, name);
    else
      await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static void _saveDocumentWeb(Uint8List data, String filename) {
    String url =
        html.Url.createObjectUrlFromBlob(html.Blob([data], 'application/pdf'));

    html.AnchorElement element =
        html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = filename;

    html.document.body!.children
      ..add(element..click())
      ..remove(element);

    html.Url.revokeObjectUrl(url);
  }
}
