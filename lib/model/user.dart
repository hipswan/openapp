import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String account;
  final String userType;

  User({
    required this.name,
    required this.account,
    required this.userType,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      name: doc['name'],
      account: doc['account'],
      userType: doc['userType'],
    );
  }
}
