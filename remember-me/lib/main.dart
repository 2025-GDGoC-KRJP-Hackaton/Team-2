import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:remember_me/app/api/api_error.dart';
import 'package:remember_me/app/api/api_service.dart';
import 'package:remember_me/app/auth/auth_service.dart';
import 'package:remember_me/app/route/router_service.dart';
import 'package:remember_me/app/service/gcs_storage_service.dart';
import 'package:remember_me/app/service/secure_storage_service.dart';
import 'package:remember_me/firebase_options.dart';

part 'service.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      await Service.initFlutter();
      await Service.initEnv();
      await Service.initFirebase();
      final serviceProviderContainer = await Service.registerServices();
      final router = RouterService.I.router;

      runApp(
        UncontrolledProviderScope(
          container: serviceProviderContainer,
          child: MaterialApp.router(
            title: 'Remember Me',
            routerConfig: router,
            theme: ThemeData(),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return Overlay(
                initialEntries: [OverlayEntry(builder: (context) => child!)],
              );
            },
          ),
        ),
      );
    },
    (error, stackTrace) {
      log('runZonedGuarded: ', error: error, stackTrace: stackTrace);
      if (error is ApiError) {
        log('ApiError: ${error.message}');
      }
      debugPrint('runZonedGuarded: $error');
    },
  );
}
