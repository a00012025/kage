import 'package:app/features/home/controllers/user_balance_controller.dart';
import 'package:app/features/home/controllers/user_txs_controller.dart';
import 'package:app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kage',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize providers by watching them.
    // By using "watch", the provider will stay alive and not be disposed.
    ref.watch(userTxsProvider);
    ref.watch(userBalanceProvider);
    return child;
  }
}
