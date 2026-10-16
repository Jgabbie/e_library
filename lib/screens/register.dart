import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String errorMessage = "";
  
  bool _isObscure = true;
  bool _isObscureConfirm = true; 

  void _clearError(String value) {
    if (errorMessage.isNotEmpty) {
      setState(() => errorMessage = "");
    }
  }

  void _handleRegister() {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => errorMessage = "All fields are required.");
      return;
    }

    if (password != confirmPassword) {
      setState(() => errorMessage = "Passwords do not match.");
      return;
    }

    if (username.length < 8 || username.length > 13) {
      setState(() => errorMessage = "Username must be between 8 and 13 characters.");
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => errorMessage = "Please enter a valid email address.");
      return;
    }

    if (password.length < 8) {
      setState(() => errorMessage = "Password must be at least 8 characters long.");
      return;
    }

    bool hasUpper = false;
    bool hasLower = false;
    bool hasDigit = false;
    bool hasSpecial = false;

    String upperLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String lowerLetters = "abcdefghijklmnopqrstuvwxyz";
    String numbers = "0123456789";

    for (int i = 0; i < password.length; i++) {
      String char = password[i];
      if (upperLetters.contains(char)) {
        hasUpper = true;
      } else if (lowerLetters.contains(char)) {
        hasLower = true;
      } else if (numbers.contains(char)) {
        hasDigit = true;
      } else if (char != ' ') { 
        hasSpecial = true;
      }
    }

    if (!hasUpper || !hasLower || !hasDigit || !hasSpecial) {
      setState(() => errorMessage = "Password needs uppercase, lowercase, number, and special char.");
      return;
    }

    for (var user in MockDatabase.users) {
      if (user["username"] == username || user["email"] == email) {
        setState(() => errorMessage = "Username or Email already exists.");
        return;
      }
    }

    MockDatabase.users.add({
      "username": username,
      "email": email,
      "password": password,
    });

    setState(() => errorMessage = "");

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Success", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        content: Text("Account successfully created! Redirecting to login...", style: TextStyle(fontSize: 16)),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context); 
        Navigator.pop(context); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Removed solid orange
        elevation: 0, // Removes shadow
        title: const Text("Create Account", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/RegisBg.jpg"),
            fit: BoxFit.cover,
            
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 25, 
              child: Container(
                alignment: Alignment.center,
                child: const Text("Join E-Library Today.", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
            Expanded(
              flex: 75,
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
                      const Text("Username", style: TextStyle(fontSize: 20)),
                      TextField(
                        controller: _usernameController,
                        onChanged: _clearError, 
                      ),
                      const SizedBox(height: 20),
                      
                      const Text("Email", style: TextStyle(fontSize: 20)),
                      TextField(
                        controller: _emailController,
                        onChanged: _clearError, 
                      ),
                      const SizedBox(height: 20),

                      const Text("Password", style: TextStyle(fontSize: 20)),
                      TextField(
                        controller: _passwordController, 
                        obscureText: _isObscure,
                        onChanged: _clearError, 
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isObscure = !_isObscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      
                      const Text("Retype Password", style: TextStyle(fontSize: 20)),
                      TextField(
                        controller: _confirmPasswordController, 
                        obscureText: _isObscureConfirm,
                        onChanged: _clearError, 
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_isObscureConfirm ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (errorMessage.isNotEmpty)
                        Text(errorMessage, style: const TextStyle(color: Colors.red)),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(400, 60),
                          backgroundColor: Colors.orange,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        onPressed: _handleRegister,
                        child: const Text("Sign Up", style: TextStyle(fontSize: 24, color: Colors.white)),
                      ),
                      const SizedBox(height: 30),
                      
                      Center(
                        child: Column(
                          children: [
                            const Text("Already have an account?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.grey)),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text("Login Here", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.orange)),
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