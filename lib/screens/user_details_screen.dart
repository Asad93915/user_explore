import 'package:flutter/material.dart';

import '../model/user_model.dart';


class UserDetailsScreen extends StatelessWidget {
  final User userDetails;

  const UserDetailsScreen({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              spacing: 15.0,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(userDetails.avatar.toString()),
                ),

                Text(
                  '${userDetails.firstName} ${userDetails.lastName}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  userDetails.email.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'ID: ${userDetails.id}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
