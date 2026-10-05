import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = "";
  
  // Added visibility state
  bool _isObscure = true; 

  void _handleLogin() {
    String identifier = _identifierController.text.trim();
    String password = _passwordController.text;

    if (identifier.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Please enter both fields.");
      return;
    }

    for (var user in MockDatabase.users) {
      if ((user["username"] == identifier || user["email"] == identifier) && user["password"] == password) {
        MockDatabase.activeUser = user;
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }
    }
    setState(() => errorMessage = "Invalid credentials.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        actions: const [
          Icon(Icons.person, color: Colors.white),
          Icon(Icons.settings, color: Colors.white),
          Icon(Icons.login, color: Colors.white),
        ],
        backgroundColor: Colors.orange,
        title: const Text("E-Library", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.orange,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 30,
              child: Container(
                alignment: Alignment.center,
                child: const Text("Welcome Back to E-Library.", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
            Expanded(
              flex: 70,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text("Username or Email", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 8),
                      TextField(controller: _identifierController),
                      const SizedBox(height: 20),
                      
                      const Text("Password", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 8),
                      
                      // Added visibility toggle decoration
                      TextField(
                        controller: _passwordController, 
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isObscure = !_isObscure),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      if (errorMessage.isNotEmpty)
                        Text(errorMessage, style: const TextStyle(color: Colors.red)),

                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/forgot_password'),
                          child: const Text("Forgot Password?", style: TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(400, 60),
                          backgroundColor: Colors.orange,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        onPressed: _handleLogin,
                        child: const Text("Login", style: TextStyle(fontSize: 24, color: Colors.white)),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            const Text("Don't have an account?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.grey)),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/register'),
                              child: const Text("Signup Here", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.orange)),
                            ),
                          ],
                        ),
                      ),
                    ],
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