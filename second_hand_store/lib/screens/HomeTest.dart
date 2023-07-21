import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/screens/pages/feed_page.dart';
import 'package:second_hand_store/screens/pages/home_page.dart';
import 'package:second_hand_store/screens/pages/login_page.dart';
import 'package:second_hand_store/screens/pages/profile_page.dart';
import 'package:second_hand_store/screens/pages/search_page.dart';

import '../provider/google_signin.dart';
import '../utils/colors.dart';

class HomeTest extends StatefulWidget {
  const HomeTest({Key? key}) : super(key: key);

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  final _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PersistentTabView(
            context,
            controller: _controller,
            screens: [
              const HomePage(),
              const SearchPage(),
              const FeedPage(),
              Builder(
                builder: (context) {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: true);

                  return provider.isLogged
                      ? ProfilePage(
                          controller: _controller,
                        )
                      : const LoginPage();
                },
              ),
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.house_alt),
                iconSize: 30,
                title: ("Pik"),
                activeColorPrimary: activeColorPrimary,
                inactiveColorPrimary: inactiveColorPrimary,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.search),
                iconSize: 30,
                title: ("Tìm"),
                activeColorPrimary: activeColorPrimary,
                inactiveColorPrimary: inactiveColorPrimary,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.layers),
                iconSize: 30,
                title: ("Feed"),
                activeColorPrimary: activeColorPrimary,
                inactiveColorPrimary: inactiveColorPrimary,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.person),
                iconSize: 30,
                title: ("Tôi"),
                activeColorPrimary: activeColorPrimary,
                inactiveColorPrimary: inactiveColorPrimary,
              ),
            ],
            confineInSafeArea: true,
            backgroundColor: Colors.white, // Default is Colors.white.
            // backgroundColor: secondaryColor, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            navBarHeight: 60,
            hideNavigationBar: true, // Ẩn BottomNavigationBar khi cần thiết
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: const NavBarDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style12, // Choose the nav bar style with this property.
          ),
          Visibility(
            visible: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBar(
                // BottomNavigationBar dùng để tạo custom TabBar khi ẩn persistent bottom nav bar
                currentIndex: _controller.index,
                onTap: (index) {
                  _controller.jumpToTab(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.house_alt),
                    label: 'Pik',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.search),
                    label: 'Tìm',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.layers),
                    label: 'Feed',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person),
                    label: 'Tôi',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
