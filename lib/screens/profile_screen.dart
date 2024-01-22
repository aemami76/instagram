import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/models.dart';
import 'package:instagram_flutter/resources/firestore_meth.dart';

import '../widgets/post_widget.dart';
import '../widgets/profile_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.userId, super.key});
  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final myUser = MyUser.instance!.id;
  late DocumentSnapshot<Map<String, dynamic>> snap;

  int postLen = 0;
  bool isFollowing = false;
  bool isLoading = false;

  int followingCount = 0;
  int followersCount = 0;

  @override
  void initState() {
    getUser();

    super.initState();
  }

  getUser() async {
    snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    var postCount = await FirebaseFirestore.instance
        .collection('posts')
        .where('id', isEqualTo: widget.userId)
        .get();
    setState(() {
      postLen = postCount.docs.length;
      isFollowing = (snap.data()!['follower'] as List).contains(myUser);
      followersCount = (snap.data()!['follower'] as List).length;
      followingCount = (snap.data()!['following'] as List).length;

      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(snap.data()!['username'].toString()),
                    centerTitle: false,
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            backgroundImage:
                                NetworkImage(snap.data()!['picUrl'].toString()),
                            radius: 40,
                          ),
                          SpecialColumn('Post', postLen),
                          SpecialColumn('Follower', followersCount),
                          SpecialColumn('Following', followingCount)
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '${snap.data()!['username']}\n\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  TextSpan(
                                    text: '  ${snap.data()!['bio']}',
                                  ),
                                ]),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: widget.userId == myUser
                                    ? ProfileButton(() {
                                        FirebaseAuth.instance.signOut();
                                      }, Colors.white38, 'Sign Out')
                                    : isFollowing
                                        ? ProfileButton(() async {
                                            await FirestoreMeth().followUser(
                                                myUser, widget.userId);
                                            setState(() {
                                              isFollowing = false;
                                              followersCount--;
                                            });
                                          }, Colors.blue, 'UnFollow')
                                        : ProfileButton(() async {
                                            await FirestoreMeth().followUser(
                                                myUser, widget.userId);
                                            setState(() {
                                              isFollowing = true;
                                              followersCount++;
                                            });
                                          }, Colors.blue, 'Follow')),
                          ],
                        ),
                      ),
                      const Divider(),
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .where('id', isEqualTo: widget.userId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              print('>>>>   ${snapshot.data!.docs.length}');
                              return Expanded(
                                child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 2),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => Scaffold(
                                                            body: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  PostWidget(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .data()),
                                                                ]),
                                                          )));
                                        },
                                        child: Image.network(
                                          snapshot.data!.docs[index]['postUrl'],
                                          fit: BoxFit.fill,
                                        ),
                                      );
                                    }),
                              );
                            }
                          }),
                    ],
                  ),
                );
              }
            })
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Column SpecialColumn(String name, int number) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(
          height: 10,
        ),
        Text(
          number.toString(),
          style: const TextStyle(fontWeight: FontWeight.w900),
        )
      ],
    );
  }
}
