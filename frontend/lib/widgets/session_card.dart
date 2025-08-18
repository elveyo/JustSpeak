import 'package:flutter/material.dart';

class SessionCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String sessionTitle;
  final String date;
  final String time;

  const SessionCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.sessionTitle,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 12),

          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  sessionTitle,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 8),

                // Date & Time chips
                Row(
                  children: [
                    _InfoChip(icon: Icons.calendar_today, label: date),
                    const SizedBox(width: 8),
                    _InfoChip(icon: Icons.access_time, label: time),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
