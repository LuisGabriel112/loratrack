import 'package:flutter/material.dart';
import 'package:appturis/Pages/OpenStreetMap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel extends StatefulWidget {
  const Hotel({super.key});

  @override
  State<Hotel> createState() => _HotelState();
}

class _HotelState extends State<Hotel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('User').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users =
              snapshot.data!.docs.map((doc) {
                try {
                  return UserDat.fromJson(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  print('Error al procesar datos de usuario: $e');
                  return UserDat(name: '', email: '', uid: '');
                }
              }).toList();
          return users.isEmpty
              ? const Center(child: Text('No hay usuarios registrados.'))
              : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserTile(user: users[index]);
                },
              );
        },
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserDat user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.imgUrl != null && user.imgUrl!.isNotEmpty
                ? NetworkImage(user.imgUrl!)
                : const AssetImage('assets/default_avatar.png')
                    as ImageProvider,
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Para que los botones queden juntos
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implementa la lógica para editar el usuario
              DatabaseMethods().showEditDialog(context, user);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              DatabaseMethods()
                  .deleteUser(user.uid)
                  .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario eliminado')),
                    );
                    (context as Element).markNeedsBuild();
                  })
                  .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al eliminar usuario: $error'),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
