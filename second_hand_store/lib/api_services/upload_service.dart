import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_watermark/image_watermark.dart';

Future<List<String>> uploadImages(
    List<XFile> imageFiles, BuildContext context) async {
  List<String> urlImageUploads = [];
  var request = http.MultipartRequest(
      'POST', Uri.parse('${dotenv.env["URL_SERVER"]}/api/upload'));

  for (var file in imageFiles) {
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      file.path,
    ));
    // final isValid = await validateImage(file);
    // if (isValid) {
    // final resizedImage = await resizeAndCompressImage(file);
    // final watermarkedImage = await addWatermarkToImage(resizedImage);
    // request.files.add(await http.MultipartFile.fromPath(
    //   'image',
    //   watermarkedImage.path,
    // ));
    // final multipartFile = http.MultipartFile.fromBytes(
    //   'image',
    //   await resizedImage.readAsBytes(),
    //   filename: 'image_${DateTime.now().millisecondsSinceEpoch}',
    //   contentType: MediaType('image', 'jpeg'),
    // );
    // }
  }

  var response = await request.send();
  if (response.statusCode == 200) {
    // Receive JSON response
    var jsonResponse = await response.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .single;

    print('Images uploaded successfully');
    print(jsonResponse);
//Lặp json trả về để lấy fileName của hình trên server
    if (jsonResponse is Map<String, dynamic>) {
      var pathList = jsonResponse['path'] as List<dynamic>?;
      pathList?.forEach((item) {
        var path = item?['filename'] as String?;
        // path != null ? print('Path: $path') : null;
        urlImageUploads.add(path!);
      });

      //trả về list url image server
      return urlImageUploads;
    }
  } else {
    print('Image upload failed');
  }
  return urlImageUploads;
}

Future<File> addWatermarkToImage(File imageFile) async {
  final bytes = await imageFile.readAsBytes();
  final watermarkedImgBytes = await ImageWatermark.addTextWatermark(
    imgBytes: bytes,
    watermarkText: 'Timeless',
    dstX: 0,
    dstY: 0,
    color: Colors.white,
  );

  final watermarkedImageFile = File('${imageFile.path}_watermarked.jpg');
  await watermarkedImageFile.writeAsBytes(watermarkedImgBytes);

  return watermarkedImageFile;
}

Future<File> resizeAndCompressImage(XFile imageFile) async {
  // Đọc dữ liệu ảnh từ XFile
  final imageData = await imageFile.readAsBytes();

  // Decode ảnh để lấy thông tin kích thước ban đầu
  final decodedImage = await decodeImageFromList(imageData);

  // Tính toán tỉ lệ giữa kích thước ban đầu và kích thước mong muốn
  final aspectRatio = decodedImage.width / decodedImage.height;
  const targetWidth = 200.0;
  final targetHeight = targetWidth / aspectRatio;

  // Resize ảnh
  final resizedImage = await FlutterImageCompress.compressWithList(
    imageData,
    minHeight: targetHeight.toInt(),
    minWidth: targetWidth.toInt(),
    quality: 80,
  );

  // Lưu ảnh vào tệp mới
  final resizedImageFile = File(imageFile.path);
  await resizedImageFile.writeAsBytes(resizedImage);

  return resizedImageFile;
}

Future<bool> validateImage(XFile imageFile) async {
  // Kiểm tra định dạng hình ảnh
  final isValidFormat = _checkImageFormat(imageFile.path);
  if (!isValidFormat) {
    print('Invalid image format');
    return false;
  }

  // Kiểm tra dung lượng hình ảnh
  final fileSize = await File(imageFile.path).length();
  if (fileSize > 5 * 1024 * 1024) {
    print('Image size exceeds 5MB');
    return false;
  }

  // Kiểm tra kích thước hình ảnh
  final decodedImage =
      await decodeImageFromList(File(imageFile.path).readAsBytesSync());
  if (decodedImage.width <= 50) {
    print('Image width should be greater than 50px');
    return false;
  }

  return true;
}

bool _checkImageFormat(String imagePath) {
  final validExtensions = ['.png', '.jpg', '.jpeg', '.gif'];
  final extension = _getExtension(imagePath);
  return validExtensions.contains(extension.toLowerCase());
}

String _getExtension(String path) {
  final extension = path.split('.').last;
  return '.$extension';
}
