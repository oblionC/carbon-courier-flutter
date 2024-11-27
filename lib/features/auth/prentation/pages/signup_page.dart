import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_green/core/theme/app_palette.dart';
import 'package:go_green/features/auth/prentation/bloc/auth_bloc.dart';
import 'package:go_green/features/auth/prentation/pages/home_page.dart';
import 'package:go_green/features/auth/prentation/pages/login_page.dart';
import 'package:go_green/features/auth/prentation/pages/widgets/auth_field.dart';
import 'package:go_green/features/auth/prentation/pages/widgets/auth_gradient_button.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_green/main.dart';
import 'package:go_green/features/auth/app_auth_context.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              AuthField(
                hinText: 'Name',
                controller: nameController,
              ),
              const SizedBox(height: 15),
              AuthField(
                hinText: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 15),
              AuthField(
                hinText: 'Password',
                controller: passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 20),
              AuthGradientButton(
                buttonText: 'Sign Up',
                onPressed: handleSignup,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, LoginPage.route());
                },
                child: RichText(
                  text: TextSpan(
                      text: "Already have an account?",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppPallete.borderColor),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppPallete.gradient1,
                                    fontWeight: FontWeight.bold,
                                  ),
                        )
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> handleSignup() async {
    final AuthResponse res = await supabase.auth.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      data: {
        "username": nameController.text.trim(),
      }
    );
  }
}
