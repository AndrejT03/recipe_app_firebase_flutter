import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login.dart';
import 'screens/home_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'services/notification_service.dart';
import 'services/api_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init(
    onNotificationTap: _openRandomMealFromNotification,
  );

  runApp(const MyApp());
}

Future<void> _openRandomMealFromNotification() async {
  final nav = navigatorKey.currentState;
  if (nav == null) return;

  final api = ApiService();
  try {
    final meal = await api.fetchRandomMeal();
    nav.push(
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(mealId: meal.id),
      ),
    );
  } catch (e) {
    debugPrint('Error loading random meal from notification: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginPage(),
        "/home": (context) => const HomeScreen(),
      },
    );
  }
}