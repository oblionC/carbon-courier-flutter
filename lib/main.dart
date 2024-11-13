import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_green/core/secrets/app_secrets.dart';
import 'package:go_green/core/theme/theme.dart';
import 'package:go_green/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:go_green/features/auth/data/repositries/auth_repositry_impl.dart';
import 'package:go_green/features/auth/domain/usecases/user_sign_up.dart';
import 'package:go_green/features/auth/prentation/bloc/auth_bloc.dart';
import 'package:go_green/features/auth/prentation/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnonkey);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => AuthBloc(
        userSignUp: UserSignUp(
          AuthRepositiryImpl(
            AuthRemoteDataSourceImpl(supabase.client),
          ),
        ),
      ),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Go Green',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}
