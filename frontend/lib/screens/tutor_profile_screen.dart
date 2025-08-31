import 'package:flutter/material.dart';
import 'package:frontend/models/booked_session.dart';
import 'package:frontend/models/certificate.dart';
import 'package:frontend/models/tutor.dart';
import 'package:frontend/models/tutor_schedule.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:frontend/providers/schedule_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/book_session_screen.dart';
import 'package:frontend/widgets/calendar.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:provider/provider.dart';

class TutorProfileScreen extends StatefulWidget {
  final int id;
  const TutorProfileScreen({super.key, required this.id});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  Tutor? _tutor;

  @override
  void initState() {
    super.initState();
    _fetchTutorData(widget.id);
  }

  Future<void> _fetchTutorData(int id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final tutor = await userProvider.getTutorData(widget.id);
      setState(() {
        _tutor = tutor;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load tutor data. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Profile',
      child:
          _tutor == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 40,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            const Color.fromARGB(255, 210, 83, 125),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/150?img=11",
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _tutor!.user.firstName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${_tutor!.languages.map((lang) => lang.name).join(' & ')} Tutor",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 20),

                          // Dugmad za tabove i Schedule
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTabButton("ABOUT", true),
                              const SizedBox(width: 10),
                              _buildTabButton("POSTS", false),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.schedule,
                                  color: Colors.purple,
                                ),
                                label: const Text(
                                  "Schedule",
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => TutorBookingScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // About sekcija
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              _tutor!.user.bio,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),

                            const SizedBox(height: 16),
                            const Text(
                              "Certificates",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_tutor!.certificates.isEmpty)
                              const Text(
                                "This trainer hasn't posted any certificates yet.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            else
                              SizedBox(
                                height: 250,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var cert in _tutor!.certificates)
                                        _buildCertificateWidget(cert),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.purple : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Shows a certificate with its image and name below.
  /// [cert] should be a map or object with 'imageUrl' and 'name' fields.
  static Widget _buildCertificateWidget(Certificate cert) {
    return Container(
      margin: const EdgeInsets.only(
        left: 0,
        right: 12.0,
      ), // Only right margin for spacing, so first one is flush left
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              cert.imageUrl!,
              width: 150,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 80,
            child: Text(
              cert.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
