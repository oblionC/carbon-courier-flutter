import 'package:flutter/material.dart';
import 'package:go_green/features/auth/app_auth_context.dart';
import 'package:go_green/core/theme/app_palette.dart';
import 'package:go_green/main.dart';
import 'package:go_green/features/auth/prentation/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String?> _username;

  @override
  void initState() {
    _username = AppAuthContext().username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: AppPallete.backgroundColor,
      ),
      body: Column(
        children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("Welcome,"),
                            FutureBuilder(
                              future: _username, 
                              builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  return Text(snapshot.data!, style: TextStyle(fontSize: 24),);
                                }
                                return Text("");
                              }
                            )
                        ],)
                      ],
                    )
                  ],
                ),
              )
            ) 
          ,)
          ,
          ElevatedButton(
            onPressed: handleLogout, 
            child: Text("Logout"))
        ],
      ),
    );
  }

  Future<void> handleLogout() async {
    await AppAuthContext.logout();
    Navigator.pushReplacement(context, LoginPage.route());
  }

  Future<String?> getUsername() async {
    String? username = await AppAuthContext().username;
    return username;
  }
}