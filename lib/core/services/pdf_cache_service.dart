import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final pdfCacheServiceProvider = Provider<PdfCacheService>((_) => PdfCacheService());

class PdfCacheService {
  final Map<String, Uint8List> _cache = {};

  Future<Uint8List> getPdf(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download PDF: ${response.statusCode}');
    }
    final bytes = response.bodyBytes;
    _cache[url] = bytes;
    return bytes;
  }

  Uint8List? getCached(String url) => _cache[url];

  bool isCached(String url) => _cache.containsKey(url);

  void clear() => _cache.clear();
}
