import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import 'package:second_hand_store/screens/pages/home_page.dart';
import 'package:second_hand_store/screens/pages/message_page.dart';
import 'package:second_hand_store/screens/pages/login_page.dart';
import 'package:second_hand_store/screens/pages/profile_page.dart';
import 'package:second_hand_store/screens/pages/search_page.dart';
import 'package:second_hand_store/utils/colors.dart';

import '../provider/google_signin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens(BuildContext context) {
    return [
      HomePage(
        controller: _controller,
      ),
      const SearchPage(),
      const MessagePage(),
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
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
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
        icon: const Icon(CupertinoIcons.ellipses_bubble),
        iconSize: 28,
        title: ("Message"),
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
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(context),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          // backgroundColor: secondaryColor, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              false, // Bằng cách đặt resizeToAvoidBottomInset thành false, Bottom Navigation Bar sẽ giữ nguyên vị trí của nó khi bàn phím xuất hiện, và không bị đẩy lên.
          // stateManagement: true, // Default is true.
          navBarHeight: 60,
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          // decoration: const NavBarDecoration(
          //   // borderRadius: BorderRadius.circular(10.0),
          //   colorBehindNavBar: Colors.white,
          // ),
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
          //lắng nghe yêu cầu ẩn hiện thanh bottom nav
          // hideNavigationBar: hideBottomNavProvider.hideBottomNavigationBar,
          navBarStyle: NavBarStyle
              .style12, // Choose the nav bar style with this property.
        ),
      ),
    );
  }
}
