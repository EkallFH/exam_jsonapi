import 'package:flutter/material.dart';
import 'package:exam_jsonapi/models/album.dart';
import 'package:exam_jsonapi/services/album_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Album> lastAlbum = [];
  bool isLoading = true;

  void fetchAlbum() async {
    try {
      final result = await AlbumService.fetchAlbum();
      setState(() {
        lastAlbum = result;
        isLoading = false;
      });
    } catch (e) {
      print('$e');
    }
  }

  void deleteAlbum(int id) async {
    try {
      await AlbumService.deleteAlbum(id);
      setState(() {
        lastAlbum.removeWhere((album) => album.id == id);
      });
    } catch (e) {
      print('Gagal Untuk Menghapus Album: $e');
    }
  }

  void updateAlbum(Album album) async {
    try {
      await AlbumService.updateAlbum(album);
      setState(() {
        final index = lastAlbum.indexWhere((a) => a.id == album.id);
        if (index != -1) {
          lastAlbum[index] = album;
        }
      });
    } catch (e) {
      print('Gagal Untuk Mengedit Album: $e');
    }
  }

  void showEditDialog(Album album) {
    final titleController = TextEditingController(text: album.title);
    final urlController = TextEditingController(text: album.url);
    final thumbnailUrlController =
        TextEditingController(text: album.thumbnailUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Album'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: thumbnailUrlController,
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedAlbum = Album(
                  albumId: album.albumId,
                  id: album.id,
                  title: titleController.text,
                  url: urlController.text,
                  thumbnailUrl: thumbnailUrlController.text,
                );
                updateAlbum(updatedAlbum);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam Json & Rest Api',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: lastAlbum.length,
              itemBuilder: (context, index) {
                final album = lastAlbum[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(album.thumbnailUrl),
                      ),
                      title: Text(album.title),
                      subtitle: Text(album.url),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => showEditDialog(album),
                            icon: const Icon(Icons.edit),
                            color: Colors.green[600],
                          ),
                          IconButton(
                            onPressed: () => deleteAlbum(album.id),
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
