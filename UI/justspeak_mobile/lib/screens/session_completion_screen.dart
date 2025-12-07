import 'package:flutter/material.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:provider/provider.dart';

class SessionCompletionScreen extends StatefulWidget {
  final int sessionId;

  const SessionCompletionScreen({super.key, required this.sessionId});

  @override
  State<SessionCompletionScreen> createState() =>
      _SessionCompletionScreenState();
}

class _SessionCompletionScreenState extends State<SessionCompletionScreen> {
  final _noteController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _completeSession() async {
    setState(() => _isSubmitting = true);

    try {
      final sessionProvider = Provider.of<SessionProvider>(
        context,
        listen: false,
      );
      final success = await sessionProvider.completeSession(
        widget.sessionId,
        _noteController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pop(true); // Return true to indicate completion
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to complete session")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session Complete"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              "Session Completed!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "You can leave a note for the student (optional).",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter session notes here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _completeSession,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Finish",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
