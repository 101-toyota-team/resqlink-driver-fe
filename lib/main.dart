import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

   // DEBUG: Check if env variables are loaded
  print('SUPABASE_URL: ${dotenv.env['SUPABASE_URL']}');
  print('SUPABASE_PUBLISHABLE_KEY: ${dotenv.env['SUPABASE_PUBLISHABLE_KEY']}');
  print('All env keys: ${dotenv.env.keys}');
  
  // Check if values exist before using them
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];
  
  if (supabaseUrl == null || supabaseKey == null) {
    print('ERROR: Environment variables missing!');
    print('URL exists: ${supabaseUrl != null}');
    print('Key exists: ${supabaseKey != null}');
    return;
  }
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
  );

  runApp(const ResQLinkDriverApp());
}

class ResQLinkDriverApp extends StatelessWidget {
  const ResQLinkDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQLink Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // 2. Ganti seluruh TextTheme default aplikasi menjadi Poppins
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}