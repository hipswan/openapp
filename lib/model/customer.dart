class Customer {
  final String name;
  final String account;
  final String userType;

  Customer({
    required this.name,
    required this.account,
    required this.userType,
  });

  // factory Customer.fromDocument(DocumentSnapshot doc) {
  //   return Customer(
  //     name: doc['name'],
  //     account: doc['account'],
  //     userType: doc['userType'],
  //   );
  // }

}
