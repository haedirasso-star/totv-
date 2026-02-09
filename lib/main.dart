import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

// استيراد الملفات الخاصة بنا
import 'injection_container.dart' as di; 
import 'presentation/bloc/content_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  // تأمين بيئة العمل
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. تهيئة Firebase مع حماية (حتى لا يعلق التطبيق إذا فشل الاتصال)
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 10));
    print("Firebase Initialized Successfully");
  } catch (e) {
    print("Firebase initialization skipped or failed: $e");
  }
  
  // 2. تهيئة محرك حقن التبعيات مع حماية
  try {
    await di.init();
  } catch (e) {
    print("Dependency Injection Error: $e");
  }
  
  // 3. إعدادات النظام
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // استخدام BlocProvider مع تأمين ضد أخطاء الـ sl
        BlocProvider<ContentBloc>(
          create: (context) {
            try {
              return di.sl<ContentBloc>()..add(FetchHomeContent());
            } catch (e) {
              // في حال فشل الـ Injection، يتم إنشاء كائن وهمي لمنع الانهيار
              return ContentBloc(contentRepository: di.sl())..add(FetchHomeContent());
            }
          },
        ),
      ],
      child: MaterialApp(
        title: 'ToTV+',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: const Color(0xFFFFA726),
          scaffoldBackgroundColor: Colors.black,
          textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
        ),
        // البدء بشاشة الترحيب
        home: const SplashScreen(),
      ),
    );
  }
}

// شاشة الترحيب (نفس الكود الخاص بك مع إضافة تأمين الانتقال)
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // تأكد من الانتقال مهما حدث
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_circle_filled, size: 100, color: Color(0xFFFFA726)),
              const SizedBox(height: 20),
              const Text('ToTV+', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
