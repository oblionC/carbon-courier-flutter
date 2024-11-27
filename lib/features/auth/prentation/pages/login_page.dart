import 'package:flutter/material.dart';
import 'package:go_green/core/theme/app_palette.dart';
import 'package:go_green/features/auth/prentation/pages/app_page.dart';
import 'package:go_green/features/auth/prentation/pages/signup_page.dart';
import 'package:go_green/features/auth/prentation/pages/widgets/auth_field.dart';
import 'package:go_green/features/auth/prentation/pages/widgets/auth_gradient_button.dart';
import 'package:go_green/main.dart';
import 'package:go_green/features/auth/app_auth_context.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();

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
                'Sign In.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
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
                buttonText: 'Sign In',
                onPressed: handleLogin,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    SignUpPage.route(),
                  );
                },
                child: RichText(
                  text: TextSpan(
                      text: "Don't have an account?",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppPallete.borderColor),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
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
  Future<void> handleLogin() async {
    try{
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      AppAuthContext.login(response.session?.accessToken, response.user?.id, response.user?.userMetadata?["username"]);
      Navigator.pushReplacement(context, AppPage.route());
    }
    catch (e) {
      print(e);
    }
  }
}