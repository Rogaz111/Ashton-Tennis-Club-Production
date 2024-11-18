import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../auth/firebase_birthdays_cr.dart';
import '../../constants/constants.dart';
import '../../models/birthdays.dart';
import '../login/login_widgets.dart';
import 'helper_widgets.dart';

class BirthdaysScreen extends StatefulWidget {
  final bool isAdmin; // Pass user role here
  const BirthdaysScreen({super.key, required this.isAdmin});

  @override
  State<BirthdaysScreen> createState() => _BirthdaysScreenState();
}

class _BirthdaysScreenState extends State<BirthdaysScreen>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> birthdays = [];
  final TextEditingController searchController = TextEditingController();
  bool dataFetched = false;
  bool isDialogLoading = false;
  var uuid = const Uuid().v4();

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this, // Ensure the widget provides TickerProvider
      duration: const Duration(seconds: 2),
    )..repeat(); // Start the animation loop

    fetchBirthdaysInit();
  }

  @override
  void dispose() {
    // Dispose AnimationController
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchBirthdaysInit() async {
    birthdays = await fetchBirthdays();
    logger.i(birthdays);
    setState(() {
      dataFetched = true; // Data fetched successfully
    });
  }

  // Filter birthdays dynamically based on search query
  List<Map<String, dynamic>> get filteredBirthdays {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      return birthdays; // Show all birthdays when search bar is empty
    }
    return birthdays
        .where((b) => b['name']!.toLowerCase().contains(query))
        .toList();
  }

  // Group Birthdays by Month
  Map<String, List<Map<String, dynamic>>> groupBirthdaysByMonth(
      List<Map<String, dynamic>> birthdays) {
    Map<String, List<Map<String, dynamic>>> groupedBirthdays = {};

    // Loop through each birthday and group them by month
    for (var birthday in birthdays) {
      DateTime date = birthday['date'] is Timestamp
          ? (birthday['date'] as Timestamp).toDate()
          : birthday['date'] as DateTime;

      String month = DateFormat('MMMM').format(date);

      if (groupedBirthdays.containsKey(month)) {
        groupedBirthdays[month]!.add(birthday);
      } else {
        groupedBirthdays[month] = [birthday];
      }
    }

    // Return a sorted map by month order
    return Map.fromEntries(groupedBirthdays.entries.toList()
      ..sort((a, b) =>
          monthOrder.indexOf(a.key).compareTo(monthOrder.indexOf(b.key))));
  }

  @override
  Widget build(BuildContext context) {
    final groupedBirthdays = groupBirthdaysByMonth(filteredBirthdays);

    return Scaffold(
      appBar: buildAppBar(context, 'Birthdays'),
      body: dataFetched
          ? Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: TextField(
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    controller: searchController,
                    onChanged: (_) =>
                        setState(() {}), // Refresh UI on text input
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: 'Search member name',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // List of Birthdays Grouped by Month
                Expanded(
                  child: ListView(
                    children: groupedBirthdays.entries.map((entry) {
                      String month = entry.key;
                      List<Map<String, dynamic>> monthBirthdays = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Month Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: Text(
                              month,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          // Birthdays List for the Month
                          ...monthBirthdays.map((birthday) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[400]!,
                                      offset: const Offset(4, 4),
                                      blurRadius: 6,
                                    ),
                                    const BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-4, -4),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Circular Avatar
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          birthday['birthdayImageUrl'] != null
                                              ? NetworkImage(
                                                  birthday['birthdayImageUrl']!)
                                              : null,
                                      child:
                                          birthday['birthdayImageUrl'] == null
                                              ? const Icon(Icons.person,
                                                  size: 30, color: Colors.grey)
                                              : null,
                                    ),
                                    const SizedBox(width: 16),
                                    // Name and Date
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            birthday['name'] ?? 'No Name',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.cake,
                                                  size: 16,
                                                  color: Colors.indigo),
                                              const SizedBox(width: 8),
                                              Text(
                                                birthday['date'] != null
                                                    ? DateFormat('d MMMM y')
                                                        .format(
                                                        (birthday['date']
                                                                is Timestamp
                                                            ? (birthday['date']
                                                                    as Timestamp)
                                                                .toDate()
                                                            : birthday['date']
                                                                as DateTime),
                                                      )
                                                    : 'No Date',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.indigo[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
          : buildLoadingIndicatorProfile(_controller),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                _showAddBirthdayDialog();
              },
              child: const Icon(Icons.cake),
            )
          : null,
    );
  }

  // Alert Dialog to display Member Birthdays
  void _showAddBirthdayDialog() {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    File? selectedImage;

    Future<void> pickImage(void Function(void Function()) setState) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Add Birthday',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => pickImage(setState),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : null,
                          child: selectedImage == null
                              ? const Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStyledTextField(
                      controller: nameController,
                      inputType: TextInputType.text,
                      labelText: 'Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    _buildStyledTextField(
                      controller: dateController,
                      inputType: TextInputType.none, // Disable keyboard input
                      labelText: 'Birthday Date',
                      icon: Icons.calendar_today,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900), // Minimum selectable date
                          lastDate: DateTime(2100), // Maximum selectable date
                        );

                        if (pickedDate != null) {
                          // Format the selected date and set it in the controller
                          dateController.text =
                              DateFormat('d MMMM y').format(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              setState(() => isDialogLoading = true);

                              // Parse date from the controller
                              DateTime parsedDate = DateFormat('d MMMM y')
                                  .parse(dateController.text.trim());

                              String? imageUrl;
                              if (selectedImage != null) {
                                imageUrl = await uploadBirthdayImage(
                                    selectedImage!, uuid);
                              }

                              var newBirthday = Birthday(
                                  name: nameController.text.trim(),
                                  date: parsedDate,
                                  birthdayImageUrl: imageUrl);

                              await addBirthday(newBirthday.toMap());

                              setState(() => isDialogLoading = false);
                              Navigator.pop(context);
                              fetchBirthdays();
                            } catch (e) {
                              setState(() => isDialogLoading = false);
                              showNeumorphicSnackbar(
                                  context, 'Error Loading Member. Error: $e');
                              logger.e("Error Loading Member. Error: $e");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isDialogLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required TextInputType inputType,
    VoidCallback? onTap, // Allow optional onTap callback
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      readOnly: onTap != null, // Make field read-only if onTap is provided
      onTap: onTap, // Call onTap when the field is tapped
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.indigo),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
        ),
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}
