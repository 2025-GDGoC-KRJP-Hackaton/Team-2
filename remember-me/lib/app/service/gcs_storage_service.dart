import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:remember_me/app/api/result.dart';
import 'package:remember_me/app/api/api_error.dart';
import 'package:remember_me/app/api/result.dart';
import 'package:path/path.dart' as path;

class GcsStorageService {
  static GcsStorageService get I => GetIt.I<GcsStorageService>();

  late final FirebaseStorage _storage;

  void init() {
    _storage = FirebaseStorage.instance;
  }

  Future<Result<String>> uploadImageToGCS(File imageFile) async {
    try {
      final fileName =
          '${path.basename(imageFile.path)}_${DateTime.now().millisecondsSinceEpoch}';
      log(imageFile.path);
      final destination = 'images/$fileName';
      final ref = _storage.ref().child(destination);
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return Result.success(downloadUrl);
    } catch (e) {
      log(e.toString());
      return Result.failure(ApiError.unknown(e));
    }
  }
}
