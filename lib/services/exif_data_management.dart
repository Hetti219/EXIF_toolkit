import 'package:flutter/services.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:native_exif/native_exif.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

class ExifDataManagement {
  //Methods for EXIF data manipulation
  Future<Map<String, dynamic>?> getExifData(File imageFile) async {
    final exif = await Exif.fromPath(imageFile.path);

    final exifMap = <String, dynamic>{};

    //Basic image information
    exifMap['Date Time Original'] =
        await exif.getAttribute(TAG_DATETIME_ORIGINAL);
    exifMap['Make'] = await exif.getAttribute(TAG_MAKE);
    exifMap['Model'] = await exif.getAttribute(TAG_MODEL);
    exifMap['Software'] = await exif.getAttribute(TAG_SOFTWARE);
    exifMap['Orientation'] = await exif.getAttribute(TAG_ORIENTATION);

    //Camera Settings
    exifMap['Exposure Time'] = await exif.getAttribute(TAG_EXPOSURE_TIME);
    exifMap['F Number'] = await exif.getAttribute(TAG_F_NUMBER);
    exifMap['ISO Speed Ratings'] = await exif.getAttribute(TAG_ISO_SPEED);
    exifMap['Focal Length'] = await exif.getAttribute(TAG_FOCAL_LENGTH);
    exifMap['Aperture Value'] = await exif.getAttribute(TAG_APERTURE_VALUE);
    exifMap['Shutter Speed Value'] =
        await exif.getAttribute(TAG_SHUTTER_SPEED_VALUE);
    exifMap['Metering Mode'] = await exif.getAttribute(TAG_METERING_MODE);
    exifMap['Flash'] = await exif.getAttribute(TAG_FLASH);
    exifMap['White Balance'] = await exif.getAttribute(TAG_WHITE_BALANCE);
    exifMap['Exposure Bias Value'] =
        await exif.getAttribute(TAG_EXPOSURE_BIAS_VALUE);

    //Lens information
    exifMap['Lens Model'] = await exif.getAttribute(TAG_LENS_MODEL);
    exifMap['Lens Serial Number'] =
        await exif.getAttribute(TAG_LENS_SERIAL_NUMBER);
    exifMap['Focal Length in 35mm Film'] =
        await exif.getAttribute(TAG_FOCAL_LENGTH_IN_35MM_FILM);

    //Image dimensions
    exifMap['Pixel X Dimension'] =
        await exif.getAttribute(TAG_PIXEL_X_DIMENSION);
    exifMap['Pixel Y Dimension'] =
        await exif.getAttribute(TAG_PIXEL_Y_DIMENSION);

    //Location data
    exifMap['Latitude'] = await exif.getAttribute(TAG_GPS_LATITUDE);
    exifMap['Longitude'] = await exif.getAttribute(TAG_GPS_LONGITUDE);
    exifMap['Altitude'] = await exif.getAttribute(TAG_GPS_ALTITUDE);
    exifMap['GPS Processing Method'] =
        await exif.getAttribute(TAG_GPS_PROCESSING_METHOD);
    exifMap['GPS Datestamp'] = await exif.getAttribute(TAG_GPS_DATESTAMP);
    exifMap['GPS Map Datum'] = await exif.getAttribute(TAG_GPS_MAP_DATUM);

    //Image color and meta data
    exifMap['Color Space'] = await exif.getAttribute(TAG_COLOR_SPACE);
    exifMap['User Comment'] = await exif.getAttribute(TAG_USER_COMMENT);
    exifMap['Copyright'] = await exif.getAttribute(TAG_COPYRIGHT);
    exifMap['Artist'] = await exif.getAttribute(TAG_ARTIST);

    return exifMap;
  }

  Future<void> saveModifiedExif(BuildContext context, File? galleryFile,
      Map<String, dynamic>? exifData) async {
    if (exifData == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No image or EXIF data to save',
              style: Theme.of(context).textTheme.bodyMedium)));
      return;
    }

    try {
      // Move the image to external storage
      final externalFile = await _moveImageToExternalStorage(galleryFile!);

      // Use the new file path for EXIF writing
      final exif = await Exif.fromPath(externalFile.path);

      // Set new EXIF attributes
      //Basic image
      if (exifData['Date Time Original'] is String) {
        await exif.writeAttribute(
            TAG_DATETIME_ORIGINAL, exifData['Date Time Original']);
        log('Saved Date time');
      }
      if (exifData['Make'] is String) {
        await exif.writeAttribute(TAG_MAKE, exifData['Make']);
        log('Saved make');
      }
      if (exifData['Model'] is String) {
        await exif.writeAttribute(TAG_MODEL, exifData['Model']);
        log('Saved model');
      }
      if (exifData['Software'] is String) {
        await exif.writeAttribute(TAG_SOFTWARE, exifData['Software']);
        log('Saved Software');
      }
      if (exifData['Orientation'] is String) {
        await exif.writeAttribute(TAG_ORIENTATION, exifData['Orientation']);
        log('Saved Orientation');
      }

      //Camera settings
      if (exifData['Exposure Time'] is String) {
        await exif.writeAttribute(TAG_EXPOSURE_TIME, exifData['Exposure Time']);
        log('Saved exposure time');
      }
      if (exifData['F Number'] is String) {
        await exif.writeAttribute(TAG_F_NUMBER, exifData['F Number']);
        log('Saved f number');
      }
      if (exifData['ISO Speed Ratings'] is String) {
        await exif.writeAttribute(TAG_ISO_SPEED, exifData['ISO Speed Ratings']);
        log('Saved iso speed');
      }
      if (exifData['Focal Length'] is String) {
        await exif.writeAttribute(TAG_FOCAL_LENGTH, exifData['Focal Length']);
        log('Saved focal len');
      }
      if (exifData['Aperture Value'] is String) {
        await exif.writeAttribute(
            TAG_APERTURE_VALUE, exifData['Aperture Value']);
        log('SavAperture Value');
      }
      if (exifData['Shutter Speed Value'] is String) {
        await exif.writeAttribute(
            TAG_SHUTTER_SPEED_VALUE, exifData['Shutter Speed Value']);
        log('Saved Shutter Speed Value');
      }
      if (exifData['Metering Mode'] is String) {
        await exif.writeAttribute(TAG_METERING_MODE, exifData['Metering Mode']);
        log('Saved metering');
      }
      if (exifData['Flash'] is String) {
        await exif.writeAttribute(TAG_FLASH, exifData['Flash']);
        log('Saved flash');
      }
      if (exifData['White Balance'] is String) {
        await exif.writeAttribute(TAG_WHITE_BALANCE, exifData['White Balance']);
        log('Saved white bal');
      }
      if (exifData['Exposure Bias Value'] is String) {
        await exif.writeAttribute(
            TAG_EXPOSURE_BIAS_VALUE, exifData['Exposure Bias Value']);
        log('Saved Exposure bias value');
      }

      //Lens information
      if (exifData['Lens Model'] is String) {
        await exif.writeAttribute(TAG_LENS_MODEL, exifData['Lens Model']);
        log('Saved lens model');
      }
      if (exifData['Lens Serial Number'] is int) {
        await exif.writeAttribute(
            TAG_LENS_SERIAL_NUMBER, exifData['Lens Serial Number']);
        log('Saved serial no');
      }
      if (exifData['Focal Length in 35mm Film'] is String) {
        await exif.writeAttribute(TAG_FOCAL_LENGTH_IN_35MM_FILM,
            exifData['Focal Length in 35mm Film']);
        log('Saved focal len 35');
      }

      //Image dimensions
      if (exifData['Pixel X Dimension'] is String) {
        await exif.writeAttribute(
            TAG_PIXEL_X_DIMENSION, exifData['Pixel X Dimension']);
        log('Saved pixel x');
      }
      if (exifData['Pixel Y Dimension'] is String) {
        await exif.writeAttribute(
            TAG_PIXEL_Y_DIMENSION, exifData['Pixel Y Dimension']);
        log('Saved pixel y');
      }

      //Location data
      if (exifData['Latitude'] is double) {
        await exif.writeAttribute(TAG_GPS_LATITUDE, exifData['Latitude']);
        log('Saved lat');
      }
      if (exifData['Longitude'] is double) {
        await exif.writeAttribute(TAG_GPS_LONGITUDE, exifData['Longitude']);
        log('Saved lon');
      }
      if (exifData['Altitude'] is double) {
        await exif.writeAttribute(TAG_GPS_ALTITUDE, exifData['Altitude']);
        log('Saved alt');
      }
      if (exifData['GPS Processing Method'] is String) {
        await exif.writeAttribute(
            TAG_GPS_PROCESSING_METHOD, exifData['GPS Processing Method']);
        log('Saved GPS Processing Method');
      }
      if (exifData['GPS Datestamp'] is String) {
        await exif.writeAttribute(TAG_GPS_DATESTAMP, exifData['GPS Datestamp']);
        log('Saved GPS Datestamp');
      }
      if (exifData['GPS Map Datum'] is String) {
        await exif.writeAttribute(TAG_GPS_MAP_DATUM, exifData['GPS Map Datum']);
        log('Saved GPS Map Datum');
      }

      //Image color and meta data
      if (exifData['Color Space'] is String) {
        await exif.writeAttribute(TAG_COLOR_SPACE, exifData['Color Space']);
        log('Saved Color Space');
      }
      if (exifData['User Comment'] is String) {
        await exif.writeAttribute(TAG_USER_COMMENT, exifData['User Comment']);
        log('Saved User Comment');
      }
      if (exifData['Copyright'] is String) {
        await exif.writeAttribute(TAG_COPYRIGHT, exifData['Copyright']);
        log('Saved Copyright');
      }
      if (exifData['Artist'] is String) {
        await exif.writeAttribute(TAG_ARTIST, exifData['Artist']);
        log('Saved Artist');
      }

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

  Future<File> _moveImageToExternalStorage(File file) async {
    final mediaDirectory = Directory(
        '/storage/emulated/0/Android/media/io.github.hetti219/EXIF Toolkit');

    await mediaDirectory.create(recursive: true);

    final originalFileNameWithoutExtension =
        file.path.split('/').last.split('.').first;

    final newFileName =
        '${originalFileNameWithoutExtension}_modified.${file.path.split('.').last}';

    final newPath = '${mediaDirectory.path}/$newFileName';

    final newFile = await file.copy(newPath);

    return newFile;
  }
}
