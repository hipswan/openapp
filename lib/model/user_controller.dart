import 'business.dart';

class User {
  final String name;
  final String account;
  final String userType;
  final Business? business;

  User({
    required this.name,
    required this.account,
    required this.userType,
    this.business,
  });

  // factory User.fromDocument(DocumentSnapshot doc) {
  //   return User(
  //     name: doc['name'],
  //     account: doc['account'],
  //     userType: doc['userType'],
  //   );
  // }
}