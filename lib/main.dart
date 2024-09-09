import 'package:flutter/material.dart';
import 'package:nightreading/homepage.dart';
import 'package:nightreading/login/signup_page.dart';
import 'package:nightreading/library/menu_page.dart';
import 'package:nightreading/login/findpassword.dart';
import 'package:nightreading/library/search_result_page.dart';
import 'package:nightreading/library/book_detail_page.dart';
import 'package:firebase_core/firebase_core.dart';

// initial firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
  runApp(const NightReadingApp());
}

class NightReadingApp extends StatelessWidget {
  const NightReadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      home: const HomePage(),
      // routes to navigate page
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/menu': (context) => const MenuPage(),
        '/findpassword': (context) => const FindPasswordPage(),
        '/searchresults': (context) => SearchResultsPage(query: ModalRoute.of(context)!.settings.arguments as String),
        '/bookdetail': (context) => BookDetailPage(bookId: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}