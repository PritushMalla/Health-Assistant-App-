import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage("assets/images/loginimg.jpeg")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Text("Strengthen Your Mental Health From Today ",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 30,
                  ),
                  Text('Lets Start Working On Improving Our Mental Health'),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'login_screen');
                        },
                        child: Text('Login'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'registration_screen');
                          },
                          child: Text('SignUp'))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
