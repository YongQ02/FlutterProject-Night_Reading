import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  _FindPasswordPageState createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  // Receive user email to manage information
  final TextEditingController _emailController = TextEditingController();
  // Initialize firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to reset password
  void _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorDialog('Email cannot be empty');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSuccessDialog('Password reset email sent. Check your inbox.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        _showErrorDialog('The email address is not valid.');
      } else if (e.code == 'user-not-found') {
        _showErrorDialog('No user found for that email.');
      } else {
        _showErrorDialog(e.message ?? 'An error occurred. Please try again.');
      }
    }
  }

  // Method to show error and success when reset password.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Page Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Reset Your Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 60),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Enter Email",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.email, color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}