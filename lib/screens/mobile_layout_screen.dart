import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/screens/search_screen.dart';

import '../model/models.dart';

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({super.key});

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> {
  int _page = 0;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_pageController.jumpToPage(_page);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          Center(
            child: InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ProfileScreen(
            userId: MyUser.instance!.id,
          )
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        activeColor: Colors.white,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    setState(() {
                      _page = 0;
                      _pageController.jumpToPage(_page);
                    });
                  },
                  icon: const Icon(Icons.house)),
              label: ''),
          BottomNavigationBarItem(
              icon: IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    setState(() {
                      _page = 1;
                      _pageController.jumpToPage(_page);
                    });
                  },
                  icon: const Icon(Icons.search)),
              label: ''),
          BottomNavigationBarItem(
              icon: IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    setState(() {
                      _page = 2;
                      _pageController.jumpToPage(_page);
                    });
                  },
                  icon: const Icon(Icons.add)),
              label: ''),
          BottomNavigationBarItem(
              icon: IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    setState(() {
                      _page = 3;
                      _pageController.jumpToPage(_page);
                    });
                  },
                  icon: const Icon(Icons.favorite)),
              label: ''),
          BottomNavigationBarItem(
              icon: IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    setState(() {
                      _page = 4;
                      _pageController.jumpToPage(_page);
                    });
                  },
                  icon: const Icon(Icons.person)),
              label: ''),
        ],
      ),
    );
  }
}
