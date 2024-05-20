import 'dart:convert';

import 'package:exam_jsonapi/models/album.dart';
import 'package:http/http.dart' as http;

class AlbumService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/albums';

  static Future<List<Album>> fetchAlbum() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/1/photos'));
      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        List<Album> lastAlbum =
            result.map((albums) => Album.fromJson(albums)).toList();
        return lastAlbum;
      } else {
        throw Exception('Gagal Untuk Menampilkan Data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> deleteAlbum(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal Untuk Menghapus Album');
    }
  }

  static Future<void> updateAlbum(Album album) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${album.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(album.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal Untuk Mengedit Album');
    }
  }

    static Future<void> addAlbum(Album album) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId': album.albumId,
          'title': album.title,
          'url': album.url,
          'thumbnailUrl': album.thumbnailUrl,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Gagal Menambah Album');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}
