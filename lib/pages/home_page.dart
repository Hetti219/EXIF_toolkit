import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? galleryFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select an image',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _showPicker(context: context);
                  },
                  child: Text(
                    'Select image to access EXIF data',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  width: 300,
                  child: galleryFile == null
                      ? Center(
                          child: Text(
                          'File not selected',
                          style: theme.textTheme.bodyMedium,
                        ))
                      : Center(
                          child: Image.file(galleryFile!),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'GFG',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPicker({required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: <Widget>[
              ListTile(
                textColor: Colors.black,
                leading: const Icon(Icons.photo_library),
                title: Text(
                  'Photo Library',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(
                  'Camera',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }

  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xFilePick = pickedFile;
    setState(() {
      if (xFilePick != null) {
        galleryFile = File(pickedFile!.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'No image selected',
          style: Theme.of(context).textTheme.bodyMedium,
        )));
      }
    });
  }

  Future<List<FileSystemEntity>> getImages() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Storage permission denied');
    }

    final directory = (await getExternalStorageDirectory())!;
    final imagePath = directory.path;

    final allFiles = Directory(imagePath).list(recursive: true);
    final imageFiles = allFiles.where((entity) =>
        entity is File &&
        (entity.path.endsWith('.jpg') ||
            entity.path.endsWith('.png') ||
            entity.path.endsWith('.jpeg')));

    return imageFiles.toList();
  }
}
