import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:remember_me/app/api/api_service.dart';
import 'package:remember_me/app/screens/home/logic/home_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remember_me/app/service/gcs_storage_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

class HomeNotifier extends Notifier<HomeState> {
  @override
  build() {
    return HomeState();
  }

  final ImagePicker _picker = ImagePicker();

  Future<String> getAnswer(String text) async {
    final result = await ApiService.I.getAnswer(text);
    return result.fold(
      onSuccess: (data) {
        return data;
      },
      onFailure: (e) {
        return "";
      },
    );
  }

  void setTab(HomeTabs tab) {
    state = state.copyWith(selectedTab: tab);
  }

  Future<bool> saveRecording(String text) async {
    state = state.copyWith(isUploading: true);

    final result = await ApiService.I.uploadTextMemory(text);
    return result.fold(
      onSuccess: (data) {
        state = state.copyWith(isUploading: false);
        return data;
      },
      onFailure: (e) {
        state = state.copyWith(isUploading: false);
        return false;
      },
    );
  }

  Future<bool?> pickImage({required bool isCamera}) async {
    state = state.copyWith(isUploading: true);
    final image = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (image != null) {
      var result = await GcsStorageService.I.uploadImageToGCS(File(image.path));
      if (!result.isSuccess) {
        state = state.copyWith(isUploading: true);
        return false;
      }
      var serverResult = await ApiService.I.uploadImageMemory(
        File(image.path),
        result.data,
      );

      return serverResult.fold(
        onSuccess: (data) {
          state = state.copyWith(isUploading: false);
          return true;
        },
        onFailure: (e) {
          state = state.copyWith(isUploading: false);
          return false;
        },
      );
    }
    return null;
  }
}
