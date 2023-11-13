import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_drawer.dart';
import 'package:social_media_app/components/my_listTile.dart';
import 'package:social_media_app/components/my_post_button.dart';
import 'package:social_media_app/components/my_textfield.dart';
import 'package:social_media_app/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController newPostController = TextEditingController();
  final FireStoreDatabase database = FireStoreDatabase();

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: const Text("E M O S P H E R E"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                      hintText: "Say here ..",
                      obsecureText: false,
                      controller: newPostController),
                ),
                MyPostButton(
                  onTap: postMessage,
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: database.getPostStream(),
            builder: (context, snapshot) {
              //show loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final posts = snapshot.data!.docs;

              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No Posts .. Post Something !"),
                  ),
                );
              }

              return Expanded(
                  child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        String message = post['PostMessage'];
                        String userEmail = post['UserEmail'];

                        return MyListTile(title: message, subtitle: userEmail);
                      }));
            },
          ),
        ],
      ),
    );
  }
}
