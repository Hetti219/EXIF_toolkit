import 'package:flutter/material.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
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
                    onPressed: () => saveModifiedExif(context),
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

  //Methods fro image picking
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
      final exifData = await getExifData(galleryFile!);
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

  //Methods for EXIF data manipulation
  Future<Map<String, dynamic>?> getExifData(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final exif = FlutterExif.fromBytes(imageBytes);

    final exifMap = <String, dynamic>{};
    exifMap['Date Time Original'] = exif.getAttribute(TAG_DATETIME_ORIGINAL);
    exifMap['Make'] = exif.getAttribute(TAG_MAKE);
    exifMap['Model'] = exif.getAttribute(TAG_MODEL);
    exifMap['Exposure Time'] = exif.getAttribute(TAG_EXPOSURE_TIME);
    exifMap['F Number'] = exif.getAttribute(TAG_F_NUMBER);
    exifMap['ISO Speed Ratings'] = exif.getAttribute(TAG_ISO_SPEED);
    exifMap['Focal Length'] = exif.getAttribute(TAG_FOCAL_LENGTH);
    exifMap['Focal Length in 35mm Film'] =
        exif.getAttribute(TAG_FOCAL_LENGTH_IN_35MM_FILM);
    exifMap['Latitude'] = exif.getAttribute(TAG_GPS_LATITUDE);
    exifMap['Longitude'] = exif.getAttribute(TAG_GPS_LONGITUDE);

    return exifMap;
  }

  Future<void> saveModifiedExif(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving EXIF not implemented yet')));
  }
}
