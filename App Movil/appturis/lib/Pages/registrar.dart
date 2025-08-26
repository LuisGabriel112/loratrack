import 'package:appturis/Pages/Turis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:appturis/Pages/OpenStreetMap.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  TextEditingController nameController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController mailController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  registro() async {
    if (passController.text != "" &&
        nameController.text != "" &&
        mailController.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user; // Obtiene el objeto User

        if (user != null) {
          String userId = user.uid; // Obtiene el UID del usuario
          Map<String, dynamic> userInfoMap = {
            "uid": userId,
            "email": email,
            "name": name,
            "photoURL": null,
          };

          await DatabaseMethods().addUser(
            userId,
            userInfoMap,
          ); // Llama a addUser

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Registro exitoso",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogIn()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "La contraseña es demasiado débil.",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "El correo electrónico ya está en uso.",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Correo electrónico inválido.",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Error al registrarse: ${e.message}",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900]!,
              Colors.orange[800]!,
              Colors.orange[400]!,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedTextKit(
                    repeatForever: false,
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        'Registro',
                        textAlign: TextAlign.start,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AnimatedTextKit(
                    repeatForever: false,
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        'Ingresa los datos para crear una cuenta',
                        textAlign: TextAlign.start,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 60),
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(225, 95, 27, .4),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: <Widget>[
                              // Name field
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese un nombre';
                                    }
                                    return null;
                                  },
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    hintText: "Nombre",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              // Email or Phone field
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese un e-mail';
                                    }
                                    return null;
                                  },
                                  controller: mailController,
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              // Password field
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese una contraseña';
                                    }
                                    return null;
                                  },
                                  controller: passController,
                                  decoration: const InputDecoration(
                                    hintText: "Contraseña",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = mailController.text;
                              name = nameController.text;
                              password = passController.text;
                            });
                          }
                          registro();
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.orange[900],
                          ),
                          child: Center(
                            child: Text(
                              "Registrate",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "O inicia sesión con:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ImagenRecovery(context),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿Ya tienes una cuenta? ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LogIn(),
                                  ),
                                );
                              },
                              child: Text(
                                "Inicia sesión",
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
