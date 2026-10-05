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
  String errorMessage = "";
  
  bool _isObscure = true;

  // A helper function to clear errors when the user starts typing/deleting
  void _clearError(String value) {
    if (errorMessage.isNotEmpty) {
      setState(() => errorMessage = "");
    }
  }

  void _handleRegister() {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "All fields are required.");
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

    // FIXED: Changed from SnackBar to a central Dialog so it cannot be missed
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents user from dismissing it by tapping outside
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Success", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        content: Text("Account successfully created! Redirecting to login...", style: TextStyle(fontSize: 16)),
      ),
    );

    // Wait 2 seconds, then pop the dialog AND pop the register screen
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context); // Close the dialog
        Navigator.pop(context); // Navigate back to login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Create Account", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 20,
            child: Container(
              alignment: Alignment.center,
              child: const Text("Join E-Library Today.", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          Expanded(
            flex: 80,
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
                      onChanged: _clearError, // FIXED: Clears error when typing
                    ),
                    const SizedBox(height: 20),
                    
                    const Text("Email", style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: _emailController,
                      onChanged: _clearError, // FIXED: Clears error when typing
                    ),
                    const SizedBox(height: 20),

                    const Text("Password", style: TextStyle(fontSize: 20)),
                    
                    TextField(
                      controller: _passwordController, 
                      obscureText: _isObscure,
                      onChanged: _clearError, // FIXED: Clears error when typing/deleting
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
    );
  }
}