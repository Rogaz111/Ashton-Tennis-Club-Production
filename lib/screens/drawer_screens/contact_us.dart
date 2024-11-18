import 'dart:io';
import 'dart:math';

import 'package:ashton_tennis_unity/models/commitee_member.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../auth/firebase_contact_us_crud.dart';
import 'helper_widgets.dart';

class ContactUsPage extends StatefulWidget {
  final bool isAdmin; // Pass user role here
  const ContactUsPage({super.key, required this.isAdmin});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> committeeMembers = [];
  bool isLoading = true;
  bool isDialogLoading = false;
  var uuid = const Uuid().v4();

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this, // Provide TickerProvider
      duration: const Duration(seconds: 2),
    )..repeat(); // Start the animation loop

    fetchCommitteeMembersInit();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  Future<void> fetchCommitteeMembersInit() async {
    setState(() => isLoading = true);
    committeeMembers = await fetchCommitteeMembers();
    setState(() => isLoading = false);
  }

  //----Alert Dialog Builder -----//
  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final phoneController = TextEditingController();
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
                        'Add Member',
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
                      controller: roleController,
                      inputType: TextInputType.text,
                      labelText: 'Role',
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 10),
                    _buildStyledTextField(
                      controller: phoneController,
                      inputType: TextInputType.number,
                      labelText: 'Phone',
                      icon: Icons.phone,
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
                            // Show loading indicator
                            setState(() => isDialogLoading = true);

                            String? imageUrl;
                            if (selectedImage != null) {
                              // Upload the image and get the download URL
                              imageUrl =
                                  await uploadMemberImage(selectedImage!, uuid);
                            }

                            CommiteeMember newMember = CommiteeMember(
                                name: nameController.text,
                                role: roleController.text,
                                phone: phoneController.text,
                                memberImageUrl: imageUrl);

                            await addCommitteeMember(newMember.toMap());

                            await fetchCommitteeMembersInit();

                            setState(() => isDialogLoading = false);
                            Navigator.pop(context);
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

  // Custom Loading Indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double angle = _controller.value * 2 * pi; // Full rotation
            double radius = 20; // Distance between balls

            // Calculate positions for two animated balls
            Offset ball1Offset = Offset(
              radius * cos(angle),
              radius * sin(angle),
            );
            Offset ball2Offset = Offset(
              radius * -cos(angle),
              radius * -sin(angle),
            );

            return Stack(
              alignment: Alignment.center,
              children: [
                // Ball 1
                Transform.translate(
                  offset: ball1Offset,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                ),
                // Ball 2
                Transform.translate(
                  offset: ball2Offset,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Add Member Alert dialog text field helper method
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required TextInputType inputType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Contact Us'),
      body: isLoading
          ? _buildLoadingIndicator() // Use custom loader here
          : Column(
              children: [
                // Informational Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.indigo[100], // Light blueish background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline, // Info icon for context
                          color: Colors.indigo,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'For any emergencies or information requests, please contact any of the members below.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Reorderable List
                Expanded(
                  child: ReorderableListView.builder(
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final member = committeeMembers.removeAt(oldIndex);
                        committeeMembers.insert(newIndex, member);
                      });
                    },
                    itemCount: committeeMembers.length,
                    itemBuilder: (context, index) {
                      final member = committeeMembers[index];
                      return Padding(
                        key: ValueKey(member),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400]!,
                                offset: const Offset(4, 4),
                                blurRadius: 8,
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4, -4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          member['name'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (widget.isAdmin)
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () async {
                                              await deleteCommitteeMember(
                                                  member['docId']);
                                              logger.i(
                                                  'Deleted member: ${member['docId']}');
                                              await fetchCommitteeMembersInit();
                                            },
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      member['role'] ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.indigo[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            size: 16, color: Colors.indigo),
                                        const SizedBox(width: 8),
                                        Text(
                                          member['phone'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    member['memberImageUrl'] != null
                                        ? NetworkImage(member['memberImageUrl'])
                                        : null,
                                child: member['memberImageUrl'] == null
                                    ? const Icon(Icons.person,
                                        size: 30, color: Colors.grey)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: _showAddMemberDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
