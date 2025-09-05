import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:loravil/Pages/map.dart';
import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
// Importa la pantalla OpenstreetmapScreen

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String username = "", password = "";
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        username = mailController.text;
        password = passController.text;
      });

      final String serverIp = '192.168.100.149';
      final url = Uri.parse('http://$serverIp:5500/login'); // Reemplaza
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'Username': username, 'Password': password}),
        );

        if (response.statusCode == 200) {
          // Authentication successful, navigate to OpenstreetmapScreen
          if (mounted) {
            // Verifica si el widget está montado
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OpenstreetmapScreen()),
            );
          }
        } else {
          if (mounted) {
            // Verifica si el widget está montado
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error de autenticación')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          // Verifica si el widget está montado
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error de conexión al servidor')),
          );
        }
        // Consider logging the exception 'e' using a proper logging mechanism
      }
    }
  }

  @override
  void dispose() {
    mailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/clock.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "LORAVIL",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(143, 148, 251, 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                key: const Key(
                                  'emailField',
                                ), // Added a key for testing
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese un usuario o EUI';
                                  }
                                  // Add more sophisticated email/EUI validation here if needed
                                  return null;
                                },
                                controller: mailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Usuario o EUI",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: const Key(
                                  'passwordField',
                                ), // Added a key for testing
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese una contraseña';
                                  }
                                  if (value.length < 6) {
                                    return 'La contraseña debe tener al menos 6 caracteres'; //added password length validation
                                  }
                                  return null;
                                },
                                controller: passController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Contraseña",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    GestureDetector(
                      //key: const Key('loginButton'), // Added a key for testing
                      onTap: _login,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
