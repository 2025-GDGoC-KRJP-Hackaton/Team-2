part of 'main.dart';

class Service {
  static Future<void> initFlutter() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static Future<void> initEnv() async {
    await dotenv.load(fileName: '.env');
  }

  static Future<ProviderContainer> registerServices() async {
    final container = ProviderContainer();
    final apiService = GetIt.I.registerSingleton(ApiService());
    GetIt.I.registerSingleton(GcsStorageService()..init());
    final secureStorageSerivce = GetIt.I.registerSingleton(
      SecureStorageService()..init(),
    );
    GetIt.I.registerSingleton(RouterService(container: container)..init());
    GetIt.I.registerSingletonAsync(
      () async =>
          AuthService(
            api: apiService,
            secureStorageService: secureStorageSerivce,
            container: container,
          ).init(),
    );

    await GetIt.I.allReady();
    return container;
  }

  static Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
