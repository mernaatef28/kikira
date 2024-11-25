import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/localvariables.dart';
import 'package:kikira/kiki_app.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();



  void _login() {
    final email = emailController.text;
    final password = passwordController.text;

    // Check the login credentials against the specific hospital admin lists
    bool isValidUser = false;
    String userHospitalName = '';
    String username = '';

    for (var hospital in hospitals) {
      if (hospital['name'] == "Central Hospital") {
        for (var adminData in centralHospitalAdmin) {
          if (adminData['email'] == email && adminData['password'] == password) {
            isValidUser = true;
            userHospitalName = hospital['name'];
            username = adminData['username'];
            break;
          }
        }
      } else if (hospital['name'] == "City Clinic") {
        for (var adminData in cityClinicAdmin) {
          if (adminData['email'] == email && adminData['password'] == password) {
            isValidUser = true;
            userHospitalName = hospital['name'];
            username = adminData['username'];
            break;
          }
        }
      } else if (hospital['name'] == "Sunshine Hospital") {
        for (var adminData in sunshineHospitalAdmin) {
          if (adminData['email'] == email && adminData['password'] == password) {
            isValidUser = true;
            userHospitalName = hospital['name'];
            username = adminData['username'];
            break;
          }
        }
      } else if (hospital['name'] == "Mountain View Health") {
        for (var adminData in mountainViewHealthAdmin) {
          if (adminData['email'] == email && adminData['password'] == password) {
            isValidUser = true;
            userHospitalName = hospital['name'];
            username = adminData['username'];
            break;
          }
        }
      }
    }

    if (isValidUser) {
      // After successful login, pass data to the main app screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => KikiRaApp(

          ),
        ),
      );
    } else {
      // Show error if invalid user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email, password, or hospital name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colorManager.kikiBlue,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),

                  // Logo
                  Image.asset('assets/images/pinguin1.png', height: 200),
                  SizedBox(height: 20),

                  // Welcome Text
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: colorManager.kikiKohly,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Email Input Field
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: colorManager.kikilavander),
                      prefixIcon: Icon(
                        Icons.email,
                        color: colorManager.kikilavander,
                      ),
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorManager.kikilavander),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Password Input Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: colorManager.kikilavander),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: colorManager.kikilavander,
                      ),
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorManager.kikilavander),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Login Button
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorManager.kikiKohly,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Forgot Password Text
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: colorManager.kikilavander),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
