import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:appturis/Pages/Inicio.dart';
import 'package:appturis/Pages/Mapa.dart';
import 'package:appturis/Pages/Comida.dart';
import 'package:appturis/Pages/Compras.dart';
import 'package:appturis/Pages/Hotel.dart';
import 'package:appturis/Pages/Perfil.dart';

//OpenStreetMap
class OpenstreetmapScreen extends StatefulWidget {
  const OpenstreetmapScreen({super.key});

  @override
  State<OpenstreetmapScreen> createState() => _OpenstreetmapScreenState();
}

class _OpenstreetmapScreenState extends State<OpenstreetmapScreen> {
  final MapController _mapController = MapController();
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de rutas"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(0, 0),
              initialZoom: 2,
              minZoom: 0,
              maxZoom: 100,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              CurrentLocationLayer(
                style: const LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(Icons.location_pin, color: Colors.white),
                  ),
                  markerSize: Size(35, 35),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//Imagenes Gmail y Apple ID
Widget ImagenRecovery(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      GestureDetector(
        child: Image.asset(
          'assets/apple.png',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(width: 50),
      GestureDetector(
        onTap: () {
          AuthMetods().signInWithGoogle(context);
        },
        child: Image.asset(
          'assets/gmail.png',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
      ),
    ],
  );
}

//Google
class AuthMetods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;
    Map<String, dynamic> userInfoMap = {
      "email": userDetails!.email,
      "name": userDetails.displayName,
      "imgUrl": userDetails.photoURL,
      "id": userDetails.uid,
    };
    await DatabaseMethods().addUser(userDetails.uid, userInfoMap).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => inicio()),
      );
    });
  }
}

class DatabaseMethods {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<void> deleteUser(String? userId) async {
    try {
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .delete();
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.delete();
        } else {
          print('Usuario no encontrado en Firebase Authentication');
        }
      } else {
        print('UserID es nulo. No se puede eliminar el usuario.');
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Stream<List<UserDat>> readUsers() => FirebaseFirestore.instance
      .collection('User')
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => UserDat.fromJson(doc.data())).toList(),
      );

  Future showEditDialog(BuildContext context, UserDat user) {
    String newName = user.name;
    String newEmail = user.email;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: TextEditingController(text: newName),
                onChanged: (value) => newName = value,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: TextEditingController(text: newEmail),
                onChanged: (value) => newEmail = value,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                try {
                  await DatabaseMethods().updateUser(
                    user.uid,
                    newName,
                    newEmail,
                  );
                  Navigator.of(context).pop();
                  (context as Element).markNeedsBuild(); //Reconstruye el widget
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario actualizado')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar usuario: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUser(String? uid, String newName, String newEmail) async {
    try {
      await FirebaseFirestore.instance.collection('User').doc(uid).update({
        'name': newName,
        'email': newEmail,
      });
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}

class UserDat {
  final String name;
  final String email;
  final String? imgUrl;
  final String? uid;

  UserDat({
    required this.name,
    required this.email,
    this.imgUrl,
    required this.uid,
  }); // uid es requerido

  factory UserDat.fromJson(Map<String, dynamic> json) {
    return UserDat(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      imgUrl: json['imgURL'] ?? '',
      uid: json['uid'],
    );
  }
}

class ImageMethods {
  Widget BuildImageRow(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          BuildImageButton(
            context,
            'assets/Inicio.png',
            const inicio(),
            'Inicio',
          ),
          BuildImageButton(context, 'assets/Mapa.jpg', const Mapa(), 'Mapa'),
          BuildImageButton(
            context,
            'assets/Compras.png',
            const Compras(),
            'Compras',
          ),
          BuildImageButton(
            context,
            'assets/Comida.png',
            const Comida(),
            'Comida',
          ),
          BuildImageButton(context, 'assets/Hotel.png', const Hotel(), 'Hotel'),
          BuildImageButton(
            context,
            'assets/Perfil.png',
            const Perfil(),
            'Perfil',
          ),
        ],
      ),
    );
  }

  Widget BuildImageButton(
    BuildContext context,
    String assetPath,
    Widget route,
    String text,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(assetPath, fit: BoxFit.contain),
            ),
          ),
          Text(text),
        ],
      ),
    );
  }

  Widget CustomHeader() {
    return Container(
      height: 275,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Container(
        child: Image.asset(
          'assets/Veracruz1.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget ImageFoods(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BuildImageButton(
                context,
                'assets/pez.png',
                const inicio(),
                'Inicio',
              ),
              BuildImageButton(
                context,
                'assets/tostadas.png',
                const Mapa(),
                'Mapa',
              ),
              BuildImageButton(
                context,
                'assets/taco.png',
                const Compras(),
                'Compras',
              ),
            ],
          ),
          SizedBox(height: 20), // Espacio entre filas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BuildImageButton(
                context,
                'assets/Snacks.png',
                const inicio(),
                'Inicio',
              ),
              BuildImageButton(
                context,
                'assets/desayuno.png',
                const Mapa(),
                'Mapa',
              ),
              BuildImageButton(
                context,
                'assets/hamburguesa.png',
                const Compras(),
                'Compras',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
