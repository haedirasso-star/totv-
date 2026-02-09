import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

// استيراد ملفاتنا التي أنشأناها خطوة بخطوة
import 'injection_container.dart' as di; 
import 'presentation/bloc/content_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  // التأكد من تهيئة أدوات فلاتر قبل أي شيء
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. تهيئة Firebase
  await Firebase.initializeApp();
  
  // 2. تهيئة محرك حقن التبعيات (Dependency Injection)
  await di.init();
  
  // 3. ضبط إعدادات شريط الحالة (Status Bar) لعام 2026
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // تثبيت اتجاه الشاشة (اختياري، يفضل تثبيته للهواتف)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // نغلف التطبيق بالكامل بالـ Bloc ليكون متاحاً في كل الصفحات
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContentBloc>(
          create: (context) => di.sl<ContentBloc>()..add(FetchHomeContent()),
        ),
      ],
      child: MaterialApp(
        title: 'ToTV+',
        debugShowCheckedModeBanner: false,
        
        // إعدادات الثيم الاحترافي - Dark Mode 2026
        theme: ThemeData(
          useMaterial3: true, // تفعيل Material 3
          brightness: Brightness.dark,
          primaryColor: const Color(0xFFFFA726),
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFA726),
            secondary: Color(0xFF1976D2),
            surface: Color(0xFF121212),
          ),
          // استخدام خط كايرو المتوافق مع التصميم العربي
          textTheme: GoogleFonts.cairoTextTheme(
            ThemeData.dark().textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)),
    );

    _controller.forward();

    // الانتقال للصفحة الرئيسية بعد انتهاء التحميل
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A1A)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شعار احترافي بسيط
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA726),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFA726).withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.play_circle_filled, size: 80, color: Colors.black),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'ToTV+',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'عالم الترفيه بين يديك',
                    style: GoogleFonts.cairo(
                      color: Colors.white60,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
