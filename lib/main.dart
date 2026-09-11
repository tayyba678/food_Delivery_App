import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Push notifications only for Android/iOS
  if (!kIsWeb) {
    await FirebaseMessaging.instance.requestPermission();

    String? token = await FirebaseMessaging.instance.getToken();

    print('🔥 FCM Token: $token');
  }

  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    );
    return true;
  };

  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Onboarding(),
    );
  }
}
  class Onboarding extends StatelessWidget{
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/intro.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
      Opacity(
        opacity: 0.5,child:
            Container(

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFCAD5D),
                    Colors.black,
                  ],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
            ),
            Positioned(
              bottom: 50,
              left:27,
              right: 27,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Find and Get\nYour Best Food",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color:Colors.white,
                        height: 1.1,
                      )
                  ),

                  const SizedBox(height:15),

                  const Text("Find the most delicious food",
                      style: TextStyle(
                        fontSize: 15,
                        color:Colors.white,
                      )
                  ),

                  const Text("with the best quality and free delivery here",
                      style: TextStyle(
                        fontSize: 15,
                        color:Colors.white,
                      )
                  ),

                  const SizedBox(height:50),

                  Align(
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
                              'assets/Ellipse 21.png',
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Image.asset(
                              'assets/Ellipse 22.png',
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/Ellipse 23.png',
                            ),
                          ),

                          Positioned(
                            top: 0,
                            left: 0,
                            child: Image.asset(
                              'assets/Ellipse 24.png',
                            ),
                          ),

                          Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF820D),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.center,
                    child:
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home(),
                        ),
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: const Color(0xFF555555),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
}