import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

String _errorMessage = '';
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 239, 200, 246), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 239, 200, 246), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String name = '';
  String role = ' ';
  String email = '';
  String password = '';
  bool showSpinner = false;
  String errorMessage = '';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();
  var items = ['Doctor', 'Patient', ' '];

  String value = ' ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your Password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              // TextField(
              //   controller: _roleController,
              //   textAlign: TextAlign.center,
              //   onChanged: (value) {
              //     role = value;
              //   },
              Text("Choose a role "),
              DropdownButton(
                value: value,
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    value = newValue!;
                    role = newValue!;
                    print(role);
                  });
                },
              ),

              SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                child: Text("Register"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                    errorMessage = '';
                  });

                  if (email.isEmpty || password.isEmpty) {
                    setState(() {
                      showSpinner = false;
                      errorMessage = 'Please fill in both fields';
                    });
                    return;
                  }

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (newUser != null) {
                      // Save additional user data in Firestore
                      // Get the current user's UID from Firebase Authentication
                      String userID = FirebaseAuth.instance.currentUser!.uid;

                      // Add user data to Firestore

                      // Add user data to Firestore
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userID)
                          .set({
                        'Userid ': userID,
                        'name': name,
                        'email': email,
                        'role': role,

                        // Leave empty if not a doctor
                      });
                      Navigator.pushNamed(context, 'home_screen');
                    }
                  } catch (e) {
                    setState(() {
                      errorMessage = e.toString();
                    });
                  }

                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validatePassword(String password) {
    bool passvalid = true;
    // Reset error message
    _errorMessage = '';
    // Password length greater than 6
    if (password.length < 6) {
      passvalid = false;
      _errorMessage += 'Password must be longer than 6 characters.\n';
    }
    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      passvalid = false;
      _errorMessage += '• Uppercase letter is missing.\n';
    }
    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      passvalid = false;
      _errorMessage += '• Lowercase letter is missing.\n';
    }
    // Contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      passvalid = false;
      _errorMessage += '• Digit is missing.\n';
    }
    // Contains at least one special character
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      passvalid = false;
      _errorMessage += '• Special character is missing.\n';
    }
    // If there are no error messages, the password is valid
    return passvalid;
  }
}
