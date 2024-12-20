import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'home_widgets.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const HomePage({super.key, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String clubImage =
      "https://langebergtennis.co.za/ashtontennisclub/sitepad-data/uploads/2024/08/Logo-3_4-1.jpg";
  final Logger logger = Logger();

  // Variables to hold user details
  String? username;
  String? email;
  String? profileImageUrl;
  String? role;
  String? uid;

  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    // Initialize user data from widget's userData parameter
    setState(() {
      username = widget.userData['username'];
      email = widget.userData['email'];
      profileImageUrl = widget.userData['profileImageUrl'];
      uid = widget.userData['uid'];
      role = widget.userData['role'];
      isAdmin = isAdministrator(role);
    });
  }

  // Function to check if logged in user is admin or member
  bool isAdministrator(userRole) {
    if (userRole == 'admin') {
      logger.i('Administrator login detected.');
      return true;
    } else {
      logger.i('Non administrator login detected.');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBarHome(context),
      drawer: buildModernDrawer(
          context, username, email, profileImageUrl, uid, isAdmin),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNeumorphicContainer(buildWelcomeBanner(username ?? 'User')),
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
          BoxShadow(
              color: Colors.grey[400]!,
              offset: const Offset(6, 6),
              blurRadius: 12),
          const BoxShadow(
              color: Colors.white, offset: Offset(-6, -6), blurRadius: 12),
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
