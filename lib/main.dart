import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:ui';
import 'utils/colors.dart';
import 'utils/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//TODO:: It will Handle push notification after user allows to send notification not in web
  await _configureFirebaseMessaging();
//TODO:: It will pass errors to firebase crashlytics except web
  _configureCrashlytics();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(720, 1600),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Onboarding(),
        ),
    );
  }
}

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //TODO:: It will show background picture with shading effects
          _buildBackground(),
          Positioned(
            bottom: 50,
            left: 27,
            right: 27,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //TODO:: This function has title and subtitles
              children: [ _buildOnBoardingPageTitle(),


                const SizedBox(height: 50),
                //TODO:: This function has a button with 4 corners
                _buildCircleButtonWithCorners(),
                const SizedBox(height: 20),
                //TODO:: It contains login button
                _buildLoginButton(context),

                //TODO:: It contains Skip button
                _buildSkipButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _configureFirebaseMessaging() async {
  if (kIsWeb) {
    return;
  }

  await FirebaseMessaging.instance.requestPermission();
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint('${AppStrings.fcmTokenLog}$token');
}

void _configureCrashlytics() {
  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
      );
      return true;
    };
  }
}

Widget _buildBackground() {
  return Stack(
    children: [
      Image.asset(
        AppStrings.introImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      Opacity(
        opacity: 0.5,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.lightOrange,
                AppColors.black,
              ],
              stops: [0.0, 0.5],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildOnBoardingPageTitle() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(AppStrings.onboardingTitle,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            height: 1.1,
          )),
      const SizedBox(height: 15),
      const Text(AppStrings.onboardingSubtitle1,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.white,
          )),
      const Text(AppStrings.onboardingSubtitle2,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.white,
          )),
    ],
  );
}

Widget _buildCircleButtonWithCorners() {
  return Align(
    alignment: Alignment.center,
    child: SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              AppStrings.ellipse21,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              AppStrings.ellipse22,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              AppStrings.ellipse23,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              AppStrings.ellipse24,
            ),
          ),
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLoginButton(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
      child: const Text(
        AppStrings.loginButton,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
    ),
  );
}

Widget _buildSkipButton(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      },
      child: const Text(
        AppStrings.skip,
        style: TextStyle(
          color: AppColors.grey,
          fontSize: 18,
        ),
      ),
    ),
  );
}
