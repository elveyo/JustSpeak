import 'dart:convert';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final IconData fallbackIcon;

  const UserAvatar({
    Key? key,
    this.imageUrl,
    this.radius = 20,
    this.backgroundColor,
    this.fallbackIcon = Icons.person,
  }) : super(key: key);

  ImageProvider? _getImageProvider() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http')) {
        return NetworkImage(imageUrl!);
      } else {
        try {
          final base64RegExp = RegExp(r'data:image/[^;]+;base64,');
          String pureBase64 = imageUrl!.replaceAll(base64RegExp, '');
          return MemoryImage(base64Decode(pureBase64));
        } catch (e) {
          print('Error decoding base64 image: $e');
          return null;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider();
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.shade200,
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Icon(fallbackIcon, size: radius, color: Colors.grey)
          : null,
    );
  }
}
