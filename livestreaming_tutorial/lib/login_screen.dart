import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/app_keys.dart';
import 'package:livestreaming_tutorial/home_screen.dart';
import 'package:livestreaming_tutorial/tutorial_user.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TutorialUser? selectedUser;
  List<TutorialUser> users = TutorialUser.users;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login as:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 90),
                  ...users.map((user) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: selectedUser?.user.id == user.user.id
                            ? Colors.green
                            : null,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedUser = user;
                        });
                      },
                      child: Text(user.user.name ?? ''),
                    );
                  }),
                  const SizedBox(height: 90),
                  TextButton(
                    onPressed: selectedUser != null
                        ? () async {
                            await StreamVideo(
                              AppKeys.streamApiKey,
                              user: selectedUser!.user,
                              userToken: selectedUser!.token,
                            ).connect();

                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          }
                        : null,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
