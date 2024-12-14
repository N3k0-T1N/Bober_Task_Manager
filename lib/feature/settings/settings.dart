import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String route = '/settings';

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 134, 11),
        title: const Text(
          'Настройки аккаунта',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              context.go('/home');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 184, 134, 11),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.brown,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.black),
                    title: const Text(
                      'Email',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      user?.email ?? 'Нет email',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const Divider(color: Colors.brown, thickness: 1),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.black),
                        onPressed: () {
                          context.go('/login');
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Выйти из аккаунта',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
