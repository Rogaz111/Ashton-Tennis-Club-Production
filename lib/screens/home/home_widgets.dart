import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../placeholder_screen.dart';
import '../drawer_screens/birthdays_screen.dart';
import '../drawer_screens/contact_us.dart';
import '../drawer_screens/my_profile.dart';
import '../login/login.dart';

//AppBar Widget
AppBar buildAppBarHome(BuildContext context) {
  return AppBar(
    title: Text(
      'Home',
      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
    ),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
    actions: [
      PopupMenuButton(
        icon: const Icon(Icons.settings),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.black54),
              title: Text('Logout', style: GoogleFonts.poppins()),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully logged out')),
              );
            },
          )
        ],
      ),
    ],
  );
}

//Drawer Widget
Widget buildModernDrawer(BuildContext context, String? username, String? email,
    String? profileImageUrl, String? userId, bool admin) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // Drawer Header
        DrawerHeader(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl)
                      : const AssetImage('assets/images/app_logo.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  username ?? 'User',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email ?? 'user@example.com',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Section 1: Features
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Features',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        buildListTile(
            Icons.article, 'Documents', context, const PlaceHolderScreen()),
        buildListTile(Icons.calendar_month, 'Calendar', context,
            const PlaceHolderScreen()),
        buildListTile(
            Icons.photo_album, 'Gallery', context, const PlaceHolderScreen()),
        buildListTile(Icons.sports_tennis, 'Rankings', context,
            const PlaceHolderScreen()),

        // Section 2: Account
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'For me',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        buildListTile(
            Icons.celebration,
            'Birthdays',
            context,
            BirthdaysScreen(
              isAdmin: admin,
            )),
        buildListTile(
            Icons.phone,
            'Contact Us',
            context,
            ContactUsPage(
              isAdmin: admin,
            )),
        buildListTile(
            Icons.person,
            'My Profile',
            context,
            MyProfile(
              uid: userId!,
            )),
      ],
    ),
  );
}

//Drawer List tile Widget
Widget buildListTile(
    IconData icon, String title, BuildContext context, Widget destination) {
  return ListTile(
    leading: Icon(icon, color: Colors.indigo),
    title: Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
  );
}

//Welcome banner widget section
Widget buildWelcomeBanner(String username) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome, $username!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Here’s what’s happening today.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    ],
  );
}

//News section widget
Widget buildNewsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Latest News',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      const SizedBox(height: 10),
      Card(
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: ListTile(
          leading: const Icon(Icons.info, color: Colors.indigo),
          title: Text('Court Renovation Completed',
              style: GoogleFonts.poppins(color: Colors.grey[800])),
          subtitle: Text('Our courts are now open for bookings!',
              style: GoogleFonts.poppins(color: Colors.grey[600])),
        ),
      ),
    ],
  );
}

//Upcoming events widget section
Widget buildUpcomingEvents() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Upcoming Events',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      const SizedBox(height: 10),
      ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.indigo),
        title: Text('Beginner’s Tournament',
            style: GoogleFonts.poppins(color: Colors.grey[800])),
        subtitle: Text('2 PM, Oct 31st',
            style: GoogleFonts.poppins(color: Colors.grey[600])),
      ),
      ListTile(
        leading: const Icon(Icons.sports_tennis, color: Colors.indigo),
        title: Text('Tennis Workshop',
            style: GoogleFonts.poppins(color: Colors.grey[800])),
        subtitle: Text('Nov 2nd, 10 AM - 1 PM',
            style: GoogleFonts.poppins(color: Colors.grey[600])),
      ),
    ],
  );
}

//Mid screen action widgets
Widget buildActionButton(IconData icon, String label) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400]!,
                offset: const Offset(6, 6),
                blurRadius: 12),
            const BoxShadow(
                color: Colors.white, offset: Offset(-6, -6), blurRadius: 12),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.indigo, size: 32),
          onPressed: () {},
        ),
      ),
      const SizedBox(height: 5),
      Text(label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800])),
    ],
  );
}

// Homepage Footer
Widget buildBottomBar() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF7986CB), Color(0xFF3F51B5)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: Text(
      'Copyright 2024 Ashton Tennis Club',
      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );
}
