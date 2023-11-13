import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_listTile.dart';
import 'package:social_media_app/helper/helper_function.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: const Text("U S E R S"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // if (snapshot.hasData == null) {
          //   return const Text("No data");
          // }

          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              //get individual details
              final user = users[index];
              String userName = user['username'];
              String userEmail = user['email'];
              return MyListTile(title: userName, subtitle: userEmail);
            },
          );
        },
      ),
    );
  }
}
