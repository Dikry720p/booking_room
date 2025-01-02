import 'package:booking_room/pages/booking_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bindings/booking_binding.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';
import 'room_page.dart';

class MainPage extends GetView<AuthController> {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BookingBinding().dependencies();
    final _pageController = PageController();
    final _currentIndex = 0.obs;

    final _pages = [
      const HomePage(),
      const RoomPage(),
      const Center(child: Text('Search')), // TODO: Implement Search page
      const BookingPage(), // TODO: Implement Booking page
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => _currentIndex.value = index,
        children: _pages,
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: _currentIndex.value,
            onTap: (index) {
              _currentIndex.value = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.meeting_room),
                label: 'Room',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online),
                label: 'Booking',
              ),
            ],
          )),
    );
  }
}
