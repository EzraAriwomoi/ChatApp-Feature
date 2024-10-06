import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/routes/routes.dart';
import 'package:ult_whatsapp/common/theme/dark_theme.dart';
import 'package:ult_whatsapp/common/theme/light_theme.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/features/auth/auth_controller.dart';
import 'package:ult_whatsapp/firebase_options.dart';
import 'package:ult_whatsapp/pages/Home/homepage.dart';
import 'package:ult_whatsapp/pages/welcome_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Remove the splash screen after Firebase initialization
  FlutterNativeSplash.remove();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ult WhatsApp',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      home: ref.watch(userInfoAuthProvider).when(
            data: (user) {
              if (user == null) {
                // No user is logged in, redirect to WelcomePage
                return const WelcomePage();
              }
              // User is authenticated, go to HomePage
              return const HomePage();
            },
            error: (error, trace) {
              return const Scaffold(
                body: Center(
                  child: Text('Something went wrong'),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Coloors.greenLight,
              ),
            ),
          ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
