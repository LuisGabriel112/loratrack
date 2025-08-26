import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/material.dart';
import 'package:appturis/Pages/OpenStreetMap.dart';

class inicio extends StatelessWidget {
  const inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ImageMethods().CustomHeader(),
          Expanded(
            child: Container(
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
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: _buildButtonRow1(context), // <-- Añadido child:
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      // Centra el Container del modelo 3D
                      child: Container(
                        width: 300,
                        height: 300,
                        color: Colors.transparent,
                        child: BabylonJSViewer(src: 'assets/Mascara.glb'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ImageMethods().BuildImageRow(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow1(BuildContext context) {
    return Container(
      // Nuevo Container para el fondo
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(84, 241, 234, 1),
                ),
                child: Text(
                  'Textiles',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(223, 175, 72, 1),
                ), // C
                child: Text(
                  'Madera',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(84, 241, 234, 1),
                ), // C
                child: Text(
                  'Ceramica',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ), // Color rojo
                child: Text(
                  'Joyeria',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ), // Texto blanco para mejor contraste
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ), // Color verde
                child: Text(
                  'Cesteria',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ), // Texto blanco
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ), // Color azul
                child: Text(
                  'Máscaras ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ), // Texto blanco
              ),
            ],
          ),
        ],
      ),
    );
  }
}
