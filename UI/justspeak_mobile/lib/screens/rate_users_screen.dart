import 'package:flutter/material.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/user_avatar.dart';

class RateUsersScreen extends StatefulWidget {
  final int sessionId;
  final int languageId;
  final int levelId;
  final List<ParticipantInfo> participants;

  const RateUsersScreen({
    super.key,
    required this.sessionId,
    required this.languageId,
    required this.levelId,
    required this.participants,
  });

  @override
  State<RateUsersScreen> createState() => _RateUsersScreenState();
}

class ParticipantInfo {
  final int userId;
  final String name;
  final String? imageUrl;

  ParticipantInfo({
    required this.userId,
    required this.name,
    this.imageUrl,
  });
}

class _RateUsersScreenState extends State<RateUsersScreen> {
  Map<int, int> _ratings = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize all ratings to 0 (not rated)
    for (var participant in widget.participants) {
      _ratings[participant.userId] = 0;
    }
  }

  Future<void> _submitRatings() async {
    // Check if all users are rated
    if (_ratings.values.any((rating) => rating == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please rate all participants'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final sessionProvider = Provider.of<SessionProvider>(
        context,
        listen: false,
      );

      final ratings = _ratings.entries
          .map((e) => {
                'userId': e.key,
                'rating': e.value,
              })
          .toList();

      await sessionProvider.rateUsers(
        widget.sessionId,
        widget.languageId,
        widget.levelId,
        ratings,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ratings submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting ratings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildStarRating(int userId, int currentRating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _ratings[userId] = starValue;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              starValue <= currentRating ? Icons.star : Icons.star_border,
              color: starValue <= currentRating
                  ? Colors.amber
                  : Colors.grey.shade400,
              size: 36,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF7E63F1),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Rate Participants',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF7E63F1),
                    const Color(0xFF7E63F1).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 64,
                    color: Colors.amber.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'How was your session?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rate your fellow participants',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.participants.length,
                itemBuilder: (context, index) {
                  final participant = widget.participants[index];
                  final rating = _ratings[participant.userId] ?? 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              UserAvatar(
                                radius: 32,
                                imageUrl: participant.imageUrl,
                                backgroundColor: const Color(0xFF7E63F1).withOpacity(0.1),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      participant.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rating == 0
                                          ? 'Tap stars to rate'
                                          : '$rating ${rating == 1 ? 'star' : 'stars'}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: rating == 0
                                            ? Colors.grey.shade600
                                            : const Color(0xFF7E63F1),
                                        fontWeight: rating == 0
                                            ? FontWeight.normal
                                            : FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildStarRating(participant.userId, rating),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRatings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E63F1),
                      disabledBackgroundColor:
                          const Color(0xFF7E63F1).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Ratings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
