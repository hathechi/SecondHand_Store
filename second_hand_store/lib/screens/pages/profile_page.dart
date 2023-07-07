import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/google_signin.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: Colors.green,
          child: Column(
            children: [
              const Center(
                child: Text("Profile Page"),
              ),
              ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logoutGoogle();
                  },
                  child: const Text('Log Out'))
            ],
          )),
    );
  }
}
