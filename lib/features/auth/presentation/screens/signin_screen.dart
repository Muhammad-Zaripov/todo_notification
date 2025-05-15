import 'package:flutter/material.dart';
import 'package:todo_app/features/auth/presentation/screens/login_screen.dart';
import 'package:todo_app/features/auth/presentation/widgets/external_auth_buttons.dart';
import 'package:todo_app/features/auth/presentation/widgets/text_form_field_widget.dart';

import '../../../todo/presentation/screens/home_screen.dart';
import '../widgets/line_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 50),
            Text('Username'),
            SizedBox(height: 8),
            WTextField(hintText: 'Enter your Username'),
            SizedBox(height: 25),
            Text('Password'),
            SizedBox(height: 8),
            WTextField(hintText: 'Enter your Password'),
            SizedBox(height: 25),
            Text('Confirm Password'),
            SizedBox(height: 8),
            WTextField(hintText: 'Confirm Password'),
            SizedBox(height: 70),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF8875FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'REGISTER',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              spacing: 15,
              children: [
                Expanded(child: Line()),
                Text('or'),
                Expanded(child: Line()),
              ],
            ),
            SizedBox(height: 30),
            ExternalAuthButtons(title: 'Register with Google'),
            SizedBox(height: 20),
            ExternalAuthButtons(title: 'Register with Appe'),
            Spacer(),
            Row(
              children: [
                Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
