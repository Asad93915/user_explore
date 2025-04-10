
import 'package:flutter/material.dart';
import 'package:user_explorer_app/screens/user_details_screen.dart';

import '../model/user_model.dart';


class UserTileWidget extends StatelessWidget {
  final User user;
  
  UserTileWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatar.toString()),
        ),
        title: Text("${user.firstName}${user.lastName}",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.w600),),
        subtitle: Text(user.email.toString(),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,fontSize: 12.0),),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserDetailsScreen(userDetails: user)),
          );
        },
      ),
    );
  }
}
