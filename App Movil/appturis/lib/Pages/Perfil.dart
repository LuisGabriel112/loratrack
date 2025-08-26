import 'package:flutter/material.dart';
import 'package:appturis/Pages/OpenStreetMap.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final List<bool> _sectionExpanded = [false, false, false, false];
  final List<String> _sectionTitles = [
    'Inforación personal',
    'Mi Actividad',
    'Pedidos/Compras',
    'Configuración',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(flex: 8, child: ListView(children: [..._buildSections()])),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ImageMethods().BuildImageRow(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSections() {
    return List.generate(_sectionTitles.length, (index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _sectionExpanded[index] = !_sectionExpanded[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    _sectionTitles[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    _sectionExpanded[index]
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Column(children: _generateOptions(index)),
            crossFadeState:
                _sectionExpanded[index]
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      );
    });
  }

  List<Widget> _generateOptions(int sectionIndex) {
    List<String> palabras = [
      "Foto de perfil",
      "Nombre completo",
      "Correo",
      "Cambiar contraseña",
      "Idioma",
      "Favoritos",
      "rutas visitadas",
      "Actividad reciente",
      "Itinerario personal",
      "Historial de compras",
      "Metodos de pago registrados",
      "Direnciones de envio",
      "Seguimiento de envios",
      "Notifiaciones",
      "Preferencias",
      "Soporte y ayuda",
      "Cerrar sesión",
    ];

    int startIndex;
    int endIndex;

    if (sectionIndex == 0) {
      startIndex = 0;
      endIndex = 5;
    } else if (sectionIndex == 1) {
      startIndex = 5;
      endIndex = 9;
    } else if (sectionIndex == 2) {
      startIndex = 9;
      endIndex = 13;
    } else if (sectionIndex == 3) {
      startIndex = 13;
      endIndex = 17;
    } else {
      return []; //Maneja índices fuera de rango
    }

    return palabras.sublist(startIndex, endIndex).map((palabra) {
      return ListTile(title: Text(palabra));
    }).toList();
  }
}
