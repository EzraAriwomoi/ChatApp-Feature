import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/routes/routes.dart';
import 'package:ult_whatsapp/common/theme/dark_theme.dart';
import 'package:ult_whatsapp/common/theme/light_theme.dart';
import 'package:ult_whatsapp/features/auth/auth_controller.dart';
// import 'package:ult_whatsapp/features/contact/contact_page.dart';
import 'package:ult_whatsapp/firebase_options.dart';
import 'package:ult_whatsapp/pages/Home/homepage.dart';
import 'package:ult_whatsapp/pages/welcome_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //These keeps the splash screen on until it loaded up all the neccessary data
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // home: const ContactPage(),
      home: ref.watch(userInfoAuthProvider).when(
            data: (user) {
              //These will make disappear the splash screen when datas are loaded
              FlutterNativeSplash.remove();
              if (user == null) return const WelcomePage();
              return const HomePage();
            },
            error: (error, trace) {
              return const Scaffold(
                body: Center(
                  child: Text('Something wrong happened'),
                ),
              );
            },
            loading: () => const SizedBox(),
          ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}