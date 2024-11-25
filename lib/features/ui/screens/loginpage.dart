import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/classes/user.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/navigations/navigation_menu.dart';
import 'package:kikira/kiki_app.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService _apiService = ApiService();
  late final Future<List<User>> currentUser ;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationMenu()
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colorManager.kikiFirozi,
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
                      color: colorManager.kikiBlack,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Email Input Field
                  TextField(
                    controller: _emailController,
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
                    controller: _passwordController,
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
                      backgroundColor: colorManager.kikiBlack,
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
    ) ;
  }
}
