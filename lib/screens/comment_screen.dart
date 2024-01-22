import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/models.dart';
import 'package:instagram_flutter/resources/firestore_meth.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen(this.func, this.postId, {super.key});
  final String postId;
  final Future Function() func;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final controller = TextEditingController();
  final myUser = MyUser.instance!;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comment')
              .orderBy('date')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return CommentWidget(snapshot.data!.docs[index]);
                  });
            }
          }),
      bottomSheet: Container(
        padding: const EdgeInsets.all(8),
        height: kBottomNavigationBarHeight + 12,
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage(myUser.picUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      hintText: 'Enter Comment', border: InputBorder.none),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    String res = await FirestoreMeth()
                        .uploadComment(controller.text, widget.postId);
                    setState(() {
                      controller.text = '';
                    });
                    await widget.func();
                    if (res.isNotEmpty) {
                      print(res);
                    }
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.blue,
                ))
          ],
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget(this.mySnap, {super.key});

  final mySnap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(mySnap['picUrl']),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                          .copyWith(bottom: 0),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: mySnap['username'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: '   ${mySnap['comment']}')
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.white54,
          thickness: 1,
        ),
      ],
    );
  }
}
