import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/application_viewmodel.dart';
import 'routes/route_manager.dart';
import 'views/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://jdqvtrcxobjltzvpfrec.supabase.co',
      anonKey: 'sb_publishable_1i8_ZppXayFT9B0hlxTFtA_QG5r2vry');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ApplicationViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student Assistant App',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromRGBO(191, 54, 12, 1),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color.fromRGBO(191, 54, 12, 1),
              foregroundColor: Colors.white,
            )),
        initialRoute: RouteManager.login,
        onGenerateRoute: RouteManager.generateRoute,
        routes: {RouteManager.login: (context) => const AuthWrapper()},
      ),
    );
  }
}
