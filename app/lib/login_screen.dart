import 'package:app/features/home/home_screen.dart';
import 'package:app/features/recover/recover_screen.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Gaps.h64,
              const Text(
                "🌗",
                style: TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
              ),
              Gaps.h12,
              Text(
                'Take Charge of Your Savings',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Gaps.h4,
              Text(
                'Smart, Secure, Yours.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              DefaultButton(
                showIcon: false,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                text: "I'm New Here",
              ),
              Gaps.h16,
              DefaultButton(
                showIcon: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecoverScreen(),
                    ),
                  );
                },
                text: "I already have an account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
