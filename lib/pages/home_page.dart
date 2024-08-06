import 'package:exif_toolkit/services/exif_data_management.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? galleryFile;
  final picker = ImagePicker();
  Map<String, dynamic>? exifData;
  final exifManagement = ExifDataManagement();

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
              child: SingleChildScrollView(
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
                  if (exifData != null)
                    Column(
                      children: exifData!.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          subtitle: TextField(
                            controller: TextEditingController(
                                text: entry.value.toString()),
                            onChanged: (value) {
                              // Update the exifData map with the new value
                              exifData![entry.key] = value;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  // Add a button to save the modified EXIF data (explained later)
                  ElevatedButton(
                    onPressed: () => exifManagement.saveModifiedExif(
                        context, galleryFile, exifData),
                    // Call the save function
                    child: Text(
                      'Save Modified EXIF',
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ]),
          ));
        },
      ),
    );
  }

  //Methods for image picking
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
    if (pickedFile != null) {
      setState(() {
        galleryFile = File(pickedFile.path);
      });

      // Call getExifData to fetch EXIF data
      final exifData = await exifManagement.getExifData(galleryFile!);
      setState(() {
        this.exifData = exifData;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'No image selected',
        style: Theme.of(context).textTheme.bodyMedium,
      )));
    }
  }
}
