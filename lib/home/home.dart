import 'package:ashton_tennis_unity/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_widgets.dart';

class HomePage extends StatefulWidget {

  final Map<String, dynamic> userData;
  const HomePage({super.key, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String clubImage = "https://langebergtennis.co.za/ashtontennisclub/sitepad-data/uploads/2024/08/Logo-3_4-1.jpg";

  // Variables to hold user details
  String? username;
  String? email;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    // Initialize user data from widget's userData parameter
    setState(() {
      username = widget.userData['username'];
      email = widget.userData['email'];
      profileImageUrl = widget.userData['profileImageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
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
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.black54),
                  title: Text('Settings', style: GoogleFonts.poppins()),
                ),
                onTap: () {
                  // Implement dark mode logic here
                },
              ),
            ],
          ),
        ],
      ),
      drawer: buildModernDrawer(context, username, email, profileImageUrl),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNeumorphicContainer(buildWelcomeBanner(clubImage, username ?? 'User')),
            //const SizedBox(height: 20),
            //_buildNeumorphicContainer(buildUpcomingEvents()),
            //const SizedBox(height: 20),
            //_buildQuickActions(),
            //const SizedBox(height: 20),
            //_buildNeumorphicContainer(buildNewsSection()),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget _buildNeumorphicContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey[400]!, offset: const Offset(6, 6), blurRadius: 12),
          const BoxShadow(color: Colors.white, offset: Offset(-6, -6), blurRadius: 12),
        ],
      ),
      child: child,
    );
  }


  //Mid screen action buttons
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildActionButton(Icons.book_online, 'Book Court'),
        buildActionButton(Icons.group, 'Find a Partner'),
        buildActionButton(Icons.calendar_today, 'View Calendar'),
      ],
    );
  }
}