import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_exif/native_exif.dart';
import 'dart:io';
import 'dart:developer';

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
    final exif = await Exif.fromPath(imageFile.path);

    final exifMap = <String, dynamic>{};
    exifMap['Date Time Original'] =
        await exif.getAttribute(TAG_DATETIME_ORIGINAL);
    exifMap['Make'] = await exif.getAttribute(TAG_MAKE);
    exifMap['Model'] = await exif.getAttribute(TAG_MODEL);
    exifMap['Exposure Time'] = await exif.getAttribute(TAG_EXPOSURE_TIME);
    exifMap['F Number'] = await exif.getAttribute(TAG_F_NUMBER);
    exifMap['ISO Speed Ratings'] = await exif.getAttribute(TAG_ISO_SPEED);
    exifMap['Focal Length'] = await exif.getAttribute(TAG_FOCAL_LENGTH);
    exifMap['Focal Length in 35mm Film'] =
        await exif.getAttribute(TAG_FOCAL_LENGTH_IN_35MM_FILM);
    exifMap['Latitude'] = await exif.getAttribute(TAG_GPS_LATITUDE);
    exifMap['Longitude'] = await exif.getAttribute(TAG_GPS_LONGITUDE);
    exifMap['Altitude'] = await exif.getAttribute(TAG_GPS_ALTITUDE);
    exifMap['Pixel X Dimension'] =
        await exif.getAttribute(TAG_PIXEL_X_DIMENSION);
    exifMap['Pixel Y Dimension'] =
        await exif.getAttribute(TAG_PIXEL_Y_DIMENSION);
    exifMap['White Balance'] = await exif.getAttribute(TAG_WHITE_BALANCE);
    exifMap['Metering Mode'] = await exif.getAttribute(TAG_METERING_MODE);
    exifMap['Flash'] = await exif.getAttribute(TAG_FLASH);
    exifMap['Lens Model'] = await exif.getAttribute(TAG_LENS_MODEL);
    exifMap['Lens Serial Number'] =
        await exif.getAttribute(TAG_LENS_SERIAL_NUMBER);

    return exifMap;
  }

  Future<void> saveModifiedExif(BuildContext context) async {
    if (galleryFile == null || exifData == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No image or EXIF data to save',
              style: Theme.of(context).textTheme.bodyMedium)));
      return;
    }

    try {
      final exif = await Exif.fromPath(galleryFile!.path);

      log('$galleryFile');

      // Set new EXIF attributes
      await exif.writeAttribute(
          TAG_DATETIME_ORIGINAL, exifData!['Date Time Original']);
      await exif.writeAttribute(TAG_MAKE, exifData!['Make']);
      await exif.writeAttribute(TAG_MODEL, exifData!['Model']);
      await exif.writeAttribute(TAG_EXPOSURE_TIME, exifData!['Exposure Time']);
      await exif.writeAttribute(TAG_F_NUMBER, exifData!['F Number']);
      await exif.writeAttribute(TAG_ISO_SPEED, exifData!['ISO Speed Ratings']);
      await exif.writeAttribute(TAG_FOCAL_LENGTH, exifData!['Focal Length']);
      await exif.writeAttribute(TAG_FOCAL_LENGTH_IN_35MM_FILM,
          exifData!['Focal Length in 35mm Film']);
      await exif.writeAttribute(TAG_GPS_LATITUDE, exifData!['Latitude']);
      await exif.writeAttribute(TAG_GPS_LONGITUDE, exifData!['Longitude']);
      await exif.writeAttribute(TAG_GPS_ALTITUDE, exifData!['Altitude']);
      await exif.writeAttribute(
          TAG_PIXEL_Y_DIMENSION, exifData!['Pixel X Dimension']);
      await exif.writeAttribute(
          TAG_PIXEL_Y_DIMENSION, exifData!['Pixel Y Dimension']);
      await exif.writeAttribute(TAG_WHITE_BALANCE, exifData!['White Balance']);
      await exif.writeAttribute(TAG_METERING_MODE, exifData!['Metering Mode']);
      await exif.writeAttribute(TAG_FLASH, exifData!['Flash']);
      await exif.writeAttribute(TAG_LENS_MODEL, exifData!['Lens Model']);
      await exif.writeAttribute(
          TAG_LENS_SERIAL_NUMBER, exifData!['Lens Serial Number']);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('EXIF data saved successfully',
              style: Theme.of(context).textTheme.bodyMedium)));
    } catch (e, s) {
      String errorMessage = 'Failed to save EXIF data: $e';
      if (e is PlatformException) {
        errorMessage += '\nPlatform-specific error: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage,
              style: Theme.of(context).textTheme.bodyMedium)));

      log('Stack Trace: $s');
    }
  }
}
