import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/firestore_meth.dart';
import 'package:instagram_flutter/screens/comment_screen.dart';
import 'package:instagram_flutter/widgets/like_anim.dart';
import 'package:intl/intl.dart';

import '../model/models.dart';

class PostWidget extends StatefulWidget {
  const PostWidget(this.snap, {super.key});

  final Map<String, dynamic> snap;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final MyUser myUser = MyUser.instance!;
  bool isAnimating = false;

  int commentCount = 0;

  Future getComment() async {
    print(commentCount);
    try {
      var snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comment')
          .get();
      setState(() {
        commentCount = snap.size;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getComment();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage:
                    NetworkImage(widget.snap['profileImage'].toString()),
              ),
              Text('  ${widget.snap['username']}'),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMeth().likePost(
                  widget.snap['postId'], myUser.id, widget.snap['like']);
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.width,
                width: double.infinity,
                child: Image.network(widget.snap['postUrl'].toString()),
              ),
              Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnimating ? 1 : 0,
                  onEnd: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: LikeAnim(
                    duration: const Duration(milliseconds: 400),
                    isAnimating: isAnimating,
                    child: const Icon(
                      Icons.favorite,
                      size: 120,
                    ),
                  ),
                ),
              )
            ]),
          ),
          Row(
            children: [
              LikeAnim(
                isAnimating: (widget.snap['like']).contains(myUser.id),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMeth().likePost(widget.snap['postId'],
                          myUser.id, widget.snap['like']);
                    },
                    icon: (widget.snap['like']).contains(myUser.id)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_border)),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              const Spacer(),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
            child: Row(
              children: [
                Text(
                  '${(widget.snap['like'] as List).length} Likes',
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                  text: '${widget.snap['username']}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(
                        text: '  ${widget.snap['desc']}',
                        style: const TextStyle(fontWeight: FontWeight.w400)),
                  ]),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CommentScreen(getComment, widget.snap['postId'])));
            },
            child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                child: Text(
                  'show all $commentCount comments',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                )),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat('yyyy-MM-dd')
                  .format(widget.snap['dateTime'].toDate()!),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
