import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/view_livestream_screen.dart';

import 'livestream_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _createLivestream(),
              child: const Text('Create Livestream'),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () => _viewLivestream(),
              child: const Text('View Livestream'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createLivestream() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LiveStreamScreen(),
      ),
    );
  }

  Future<void> _viewLivestream() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ViewLivestreamScreen(),
      ),
    );
  }
}
