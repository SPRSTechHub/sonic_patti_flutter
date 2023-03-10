import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonicpattilive/utils/constants.dart';
import 'package:sonicpattilive/views/gameScreens/gameboard.dart';
import 'package:sonicpattilive/views/notifications.dart';
import 'package:sonicpattilive/views/splashscreen.dart';
import 'controllers/controller_binding.dart';
import 'firebase_options.dart';
import 'utils/color_schemes.g.dart';
import 'views/obscreen/screen_one.dart';

bool? initFirst;
bool? isLogin;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  LocalNotification.initialize();
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      if (message.notification != null) {
        LocalNotification.showNotification(message);
      }
    },
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  await GetStorage.init();
  initFirst = GetStorage().read('initFirst');
  if (Constant.box.read('IS_DARK_MODE') == null) {
    Get.isDarkMode
        ? GetStorage().write('IS_DARK_MODE', false)
        : GetStorage().write('IS_DARK_MODE', true);
  }

  GetStorage().write('fcmToken', fcmToken ?? false);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinding(),
      debugShowCheckedModeBanner: false,
      title: 'Sonic Patti',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,
      home: /*  AnimatedSplashScreen(
        duration: 1000,
        splashIconSize: 90,
        splash: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: const Image(
              width: 90,
              height: 90,
              image: AssetImage("assets/icon/logo_sonic.png")),
        ),
        nextScreen: openApp(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.yellow,
      ) */
          openApp(),
    );
  }

  openApp() {
    if (Constant.box.read('isLogin') == true) {
      return const GameBoard();
    } else {
      return initFirst != true
          ? OnboardingScreenOne()
          : const MainScreen(); //LoginScreen();
    }
  }
}
