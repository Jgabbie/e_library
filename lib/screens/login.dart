import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //constructor
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
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
                child: Text(
                  "Welcome Back to E-Library.",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight(800),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 70,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 35),

                    Text("Username", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 8),

                    TextField(),
                    SizedBox(height: 20),

                    Text("Password", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 8),

                    TextField(),
                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),

                    SizedBox(height: 25),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor: Colors.orange,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () => {},
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 75),

                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight(800),
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "Signup Here",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight(800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          Icon(Icons.person, color: Colors.white),
          Icon(Icons.settings, color: Colors.white),
          Icon(Icons.login, color: Colors.white),
        ],
        backgroundColor: Colors.orange,
        title: Text("E-Library", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
